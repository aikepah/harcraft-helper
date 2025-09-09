

namespace :recipes do
    desc "Import recipes from crafting-recipes.json and link to components via CraftableItemComponent"
    task :import_from_json, [ :file ] => :environment do |t, args|
      require "json"
      path = args[:file] ? Pathname.new(args[:file]) : Rails.root.join("lib", "crafting-recipes.json")
      data = JSON.parse(File.read(path))

      updated = 0
      created = 0

      def process_recipe_item(name, component_name, rarity, price, metatag)
        component = Component.find_by(name: component_name)
        unless component
          puts "Component not found for recipe: #{name} (component name: #{component_name})"
          return :missing
        end
        craftable_item = CraftableItem.find_or_initialize_by(name: name)
        craftable_item.rarity = rarity if rarity
        craftable_item.material_cost = price if price
        desc = ""
        desc += "Monster: #{metatag}\n" if metatag
        craftable_item.description = desc unless desc.empty?
        was_persisted = craftable_item.persisted?
        craftable_item.save!
        unless craftable_item.components.exists?(component.id)
          CraftableItemComponent.create!(craftable_item: craftable_item, component: component)
        end
        was_persisted ? :updated : :created
      end

      data.each do |recipe|
        if recipe["variants"] && recipe["variants"].is_a?(Array)
          recipe["variants"].each do |variant|
            variant_name = variant["mod"] ? "#{recipe["name"]} (#{variant["mod"]})" : recipe["name"]
            component_name = variant["component"] || recipe["component"]
            result = process_recipe_item(
              variant_name,
              component_name,
              recipe["rarity"],
              variant["price"] || recipe["price"],
              variant["metatag"]
            )
            updated += 1 if result == :updated
            created += 1 if result == :created
          end
        else
          next unless recipe["name"] && recipe["component"]
          result = process_recipe_item(
            recipe["name"],
            recipe["component"],
            recipe["rarity"],
            recipe["price"],
            recipe["metatag"]
          )
          updated += 1 if result == :updated
          created += 1 if result == :created
        end
      end
      puts "Updated #{updated} craftable items from JSON."
      puts "Created #{created} new craftable items from JSON."
    end
end
