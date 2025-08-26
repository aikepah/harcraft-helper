require "csv"

namespace :crafting do
  desc "Import craftable items and recipes from citems.csv"
  task import_csv: :environment do
    file_path = Rails.root.join("citems.csv")
    unless File.exist?(file_path)
      puts "citems.csv not found!"
      exit 1
    end

    rarity_map = {
      "C" => "common",
      "U" => "uncommon",
      "R" => "rare",
      "V" => "very rare",
      "L" => "legendary",
      "A" => "artifact"
    }

    flagged_rows = []
    imported = 0
    CSV.foreach(file_path, headers: true) do |row|
      name = row["Name"]&.strip
      item_type = row["Type"]&.strip
      value = row["Value"]&.gsub(",", "")&.to_i
      rarity = rarity_map[row["Rarity"]&.strip] || row["Rarity"]
      att = row["Att"]&.strip

    # Lower snake case for matching
    monster_type = row["Monster Type"]&.strip&.downcase&.gsub(/[^a-z0-9]+/, "_")
    metatag = row["Metatag"]&.strip
    component_type = row["Component"]&.strip&.downcase&.gsub(/[^a-z0-9]+/, "_")

      # Compose description
      desc_lines = []
      desc_lines << "Requires Attunement" if att == "Req"
      desc_lines << "Monster: #{metatag}" unless metatag.nil? || metatag.empty?
      description = desc_lines.join("\n")

      # Find the component
      component = Component.find_by(component_type: component_type, monster_type: monster_type)
      unless component
        flagged_rows << { name: name, component_type: component_type, monster_type: monster_type }
        next
      end


      # Create or update the craftable item (allow same name with different rarity)
      ci = CraftableItem.find_or_initialize_by(name: name, rarity: rarity)
      ci.item_type = item_type
      ci.material_cost = value
      ci.description = description
      ci.save!

      # Link the component (one per item)
      CraftableItemComponent.find_or_create_by!(craftable_item: ci, component: component)
      imported += 1
    end

    puts "Imported #{imported} craftable items."
    if flagged_rows.any?
      puts "Rows needing attention (missing component):"
      flagged_rows.each do |row|
        puts "  Item: #{row[:name]}, Component: #{row[:component_type]}, Monster Type: #{row[:monster_type]}"
      end
    end
  end
end
