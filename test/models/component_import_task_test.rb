require "test_helper"
require "rake"

class ComponentImportTaskTest < ActiveSupport::TestCase
  def setup
    Rails.application.load_tasks
    Rake::Task.define_task(:environment)
    CraftableItemComponent.delete_all if defined?(CraftableItemComponent)
  PartyComponent.delete_all if defined?(PartyComponent)
  Component.delete_all
    # Seed a few components for import to update
    Component.create!(monster_type: "aberration", component_type: "bone", dc: 1, edible: false, volatile: false, note: "")
    Component.create!(monster_type: "beast", component_type: "eye", dc: 1, edible: false, volatile: false, note: "")
  end

  def test_import_from_yaml_updates_components
    Rake::Task["components:import_from_yaml"].reenable
    Rake::Task["components:import_from_yaml"].invoke
    aberration_bone = Component.find_by(monster_type: "aberration", component_type: "bone")
    assert_equal 10, aberration_bone.dc
    assert_equal true, aberration_bone.edible
    assert_equal false, aberration_bone.volatile
    assert_equal "", aberration_bone.note
  end

  def test_import_from_yaml_skips_missing_components
    # Should not raise error if a component is missing
    Component.where(monster_type: "beast", component_type: "eye").delete_all
    Rake::Task["components:import_from_yaml"].reenable
    assert_nothing_raised do
      Rake::Task["components:import_from_yaml"].invoke
    end
  end
end
