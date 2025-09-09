

namespace :recipes do
    desc "Import recipes from crafting-recipes.json and link to components via CraftableItemComponent"
    task :import_from_json, [ :file ] => :environment do |t, args|
      require "json"
      path = args[:file] ? Pathname.new(args[:file]) : Rails.root.join("lib", "crafting-recipes.json")
      data = JSON.parse(File.read(path))

      updated = 0
      created = 0
      data.each do |recipe|
        if recipe["variants"] && recipe["variants"].is_a?(Array)
          recipe["variants"].each do |variant|
            variant_name = variant["mod"] ? "#{recipe["name"]} (#{variant["mod"]})" : recipe["name"]
            component_name = variant["component"] || recipe["component"]
            component = Component.find_by(name: component_name)
            unless component
              puts "Component not found for recipe variant: #{variant_name} (component name: #{component_name})"
              next
            end
            craftable_item = CraftableItem.find_or_initialize_by(name: variant_name)
            craftable_item.rarity = recipe["rarity"] if recipe["rarity"]
            craftable_item.material_cost = variant["price"] || recipe["price"] if variant["price"] || recipe["price"]
            # Set description with metatag if present
            desc = ""
            desc += "Monster: #{variant["metatag"]}\n" if variant["metatag"]
            craftable_item.description = desc unless desc.empty?
            if craftable_item.persisted?
              updated += 1
            else
              created += 1
            end
            craftable_item.save!
            unless craftable_item.components.exists?(component.id)
              CraftableItemComponent.create!(craftable_item: craftable_item, component: component)
            end
          end
        else
          next unless recipe["name"] && recipe["component"]
          component = Component.find_by(name: recipe["component"])
          unless component
            puts "Component not found for recipe: #{recipe["name"]} (component name: #{recipe["component"]})"
            next
          end
          craftable_item = CraftableItem.find_or_initialize_by(name: recipe["name"])
          craftable_item.rarity = recipe["rarity"] if recipe["rarity"]
          craftable_item.material_cost = recipe["price"] if recipe["price"]
          # Set description with metatag if present
          desc = ""
          desc += "Monster: #{recipe["metatag"]}\n" if recipe["metatag"]
          craftable_item.description = desc unless desc.empty?
          if craftable_item.persisted?
            updated += 1
          else
            created += 1
          end
          craftable_item.save!
          unless craftable_item.components.exists?(component.id)
            CraftableItemComponent.create!(craftable_item: craftable_item, component: component)
          end
        end
      end
      puts "Updated #{updated} craftable items from JSON."
      puts "Created #{created} new craftable items from JSON."
    end
end
