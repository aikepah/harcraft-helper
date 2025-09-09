require "test_helper"
require "rake"


class RecipeImportTaskTest < ActiveSupport::TestCase
  def setup
    Rails.application.load_tasks
    Rake::Task.define_task(:environment)
    CraftableItemComponent.delete_all
    CraftableItem.delete_all
    Component.delete_all
  # Seed a component with a known name for linking
  @component = Component.create!(monster_type: "dragon", component_type: "phial_of_blood", name: "Test Component")
  end

  def test_import_from_json_creates_and_links_craftable_items
    # Create a minimal crafting-recipes.json file

    # Use a fixture file for the test, backup and restore the real file
    require "fileutils"
    # Use a fixture file in test/fixtures and pass it as an argument to the Rake task
    fixture_path = Rails.root.join("test", "fixtures", "test-crafting-recipes.json")
    Rake::Task["recipes:import_from_json"].reenable
    output = capture_io do
      Rake::Task["recipes:import_from_json"].invoke(fixture_path.to_s)
    end

    craftable_item = CraftableItem.find_by(name: "Test Recipe")
    assert craftable_item, "CraftableItem should be created"
    # Check the join model
    cic = CraftableItemComponent.find_by(craftable_item: craftable_item, component: @component)
    assert cic, "CraftableItemComponent should link the item and component"
  end
end
