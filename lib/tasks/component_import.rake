# lib/tasks/component_import.rake
namespace :components do
  desc 'Import DC, edible, volatile, and note values from YAML into components table'
  task import_from_yaml: :environment do
    require 'yaml'
    path = Rails.root.join('config', 'component_dcs.yml')
    data = YAML.load_file(path)

    updated = 0
    data.each do |monster_type, comps|
      comps.each do |component_type, attrs|
        attrs ||= {}
        dc = attrs['dc']
        edible = attrs.key?('edible') ? attrs['edible'] : false
        volatile = attrs.key?('volatile') ? attrs['volatile'] : false
        note = attrs['note'] || ""
        next unless dc # skip if no DC
        component = Component.find_by(monster_type: monster_type, component_type: component_type)
        if component
          component.update(dc: dc, edible: edible, volatile: volatile, note: note)
          updated += 1
        else
          puts "No component found for #{monster_type} / #{component_type}"
        end
      end
    end
    puts "Updated #{updated} components from YAML."
  end
end
