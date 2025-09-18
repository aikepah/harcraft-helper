# lib/tasks/component_import.rake

namespace :components do
  desc "Import components from harvesting-components.json into the components table"
  task import_from_json: :environment do
    require "json"
    path = Rails.root.join("lib", "harvesting-components.json")
    data = JSON.parse(File.read(path))

    updated = 0
    created = 0

    def process_component_item(item)
      return :skipped unless item["name"]
      name = item["name"]
      monster_type = item["creatureType"].to_s.downcase
      component_type = name.gsub(/^#{item["creatureType"]}\s+/i, "")
      component_type = component_type.gsub(/\b#{item["creatureType"]}\b/i, "").gsub(/\s+/, " ").strip
      component_type_enum = component_type.downcase.gsub(/[\s\-]+/, "_").gsub(/[^a-z0-9_]/, "")
      unless Component.component_types.key?(component_type_enum)
        puts "Skipped: #{name} (component_type: #{component_type_enum})"
        return :skipped
      end
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
        :updated
      else
        Component.create!(attrs)
        :created
      end
    end

    data.each do |item|
      result = process_component_item(item)
      updated += 1 if result == :updated
      created += 1 if result == :created
    end
    puts "Updated #{updated} components from JSON."
    puts "Created #{created} new components from JSON."
  end
end
