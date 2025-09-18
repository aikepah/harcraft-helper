namespace :craftable_items do
  desc "Import craftable items from craftableitems.csv and link to components via CraftableItemComponent"
  task :import_from_csv, [ :file ] => :environment do |t, args|
    require "csv"
    path = args[:file] ? Pathname.new(args[:file]) : Rails.root.join("lib", "craftableitems.csv")
    data = CSV.parse(File.read(path), headers: true)

    updated = 0
    created = 0
    missing_components = Set.new

    def construct_component_name(monster_type, component)
      return nil if component.blank?
      return component if monster_type.blank?

      component = component.titleize
      result = nil
      # Handle different container patterns
      if component.start_with?("Phial Of")
        result = component.sub("Phial Of", "Phial of #{monster_type}")
      elsif component.start_with?("Pouch Of")
        result = component.sub("Pouch Of", "Pouch of #{monster_type}")
      elsif component.start_with?("Bundle Of")
        result = component.sub("Bundle Of", "Bundle of #{monster_type}")
      elsif component.start_with?("Volatile Mote Of")
        result = component.sub("Volatile Mote Of", "Volatile Mote of #{monster_type}")
      elsif component.start_with?("Core Of")
        result = component.sub("Core Of", "Core of #{monster_type}")
      else
        result = "#{monster_type} #{component}"
      end

      # Titleize the result to match database capitalization
      result
    end

    def process_craftable_item(name, item_type, monster_type, component_raw, rarity, material_cost, metatag, att, missing_components)
      component_name = construct_component_name(monster_type, component_raw)
      component = component_name.present? ? Component.find_by(name: component_name) : nil
      if component_raw.present? && component.nil?
        missing_components.add({
          constructed_name: component_name,
          component_type: component_raw,
          monster_type: monster_type,
          item_name: name
        })
        return :missing
      end
      craftable_item = CraftableItem.find_or_initialize_by(name: name)
      craftable_item.item_type = item_type if item_type.present?
      craftable_item.rarity = rarity if rarity.present?
      craftable_item.material_cost = material_cost if material_cost.present?

      desc = ""
      desc += "Monster: #{metatag}\n" if metatag.present?

      # Map Att field to description
      if att.present?
        attunement_text = case att
        when "Req"
          "Requires Attunement"
        when "-C"
          "Consumable"
        when "Opt"
          "Optional Attunement"
        when "Enh"
          "Enhanced Attunement"
        else
          nil
        end
        desc += "#{attunement_text}\n" if attunement_text
      end

      craftable_item.description = desc unless desc.empty?
      was_persisted = craftable_item.persisted?
      craftable_item.save!
      if component
        unless craftable_item.components.exists?(component.id)
          CraftableItemComponent.create!(craftable_item: craftable_item, component: component)
        end
      end
      was_persisted ? :updated : :created
    end

    data.each do |row|
      name = row["Name"]
      next unless name.present?
      item_type = row["Type"]  # Item type like "Ammunition (any)"
      monster_type = row["Component Type"]  # Monster type is in column 6 (0-indexed as 5)
      component_raw = row["Component"]
      rarity = row["Rarity"]
      material_cost = row["Value"]
      metatag = row["Metatag"]
      att = row["Att"]  # Attunement/consumable info
      result = process_craftable_item(name, item_type, monster_type, component_raw, rarity, material_cost, metatag, att, missing_components)
      updated += 1 if result == :updated
      created += 1 if result == :created
    end
    puts "Updated #{updated} craftable items from CSV."
    puts "Created #{created} new craftable items from CSV."

    # Write missing components to CSV
    if missing_components.any?
      missing_csv_path = Rails.root.join("lib", "missing_components.csv")
      CSV.open(missing_csv_path, "w") do |csv|
        csv << [ "Constructed Component Name", "Component Type", "Monster Type", "Item Name" ]
        missing_components.each do |missing|
          csv << [ missing[:constructed_name], missing[:component_type], missing[:monster_type], missing[:item_name] ]
        end
      end
      puts "Found #{missing_components.size} unique missing components. Written to #{missing_csv_path}"
    else
      puts "No missing components found!"
    end
  end
end
