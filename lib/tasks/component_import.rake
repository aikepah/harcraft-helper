# lib/tasks/component_import.rake

namespace :components do
  desc "Import components from harvesting-components.json into the components table"
  task import_from_json: :environment do
    require "json"
    path = Rails.root.join("lib", "harvesting-components.json")
    data = JSON.parse(File.read(path))

    updated = 0
    created = 0
    data.each do |item|
      next unless item["id"] && item["name"]
      # Set name directly from JSON
      name = item["name"]
      # Downcase monster type to match enum
      monster_type = item["creatureType"].to_s.downcase
      # Remove leading monster type from name for component_type
      component_type = name.gsub(/^#{item["creatureType"]}\s+/i, "")
      component_type = component_type.gsub(/\b#{item["creatureType"]}\b/i, "").gsub(/\s+/, " ").strip
      # Convert to enum format: downcase, spaces/dashes to underscores
      component_type_enum = component_type.downcase.gsub(/[\s\-]+/, "_").gsub(/[^a-z0-9_]/, "")
      # Only import if the component_type_enum is valid
      if Component.component_types.key?(component_type_enum)
        component = Component.find_by(monster_type: monster_type, component_type: component_type_enum)
        attrs = {
          monster_type: monster_type,
          name: name,
          component_type: component_type_enum,
          dc: item["dc"],
          crafting: item["crafting"],
          edible: item["edible"],
          volatile: item["volatile"],
          note: item["notes"]
        }.compact
        if component
          component.update(attrs)
          updated += 1
        else
          Component.create!(attrs)
          created += 1
        end
      else
        puts "Skipped: #{name} (component_type: #{component_type_enum})"
      end
    end
    puts "Updated #{updated} components from JSON."
    puts "Created #{created} new components from JSON."
  end
end
