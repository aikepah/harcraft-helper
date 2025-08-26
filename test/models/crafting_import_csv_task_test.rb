require "test_helper"
require "rake"
require "csv"

class CraftingImportCsvTaskTest < ActiveSupport::TestCase
  def setup
    Rails.application.load_tasks
    Rake::Task.define_task(:environment)
    CraftableItemComponent.delete_all
  CraftableItem.delete_all
  Component.delete_all
    # Seed components for matching
    Component.create!(monster_type: "dragon", component_type: "phial_of_blood")
    Component.create!(monster_type: "construct", component_type: "plating")
  end

  def test_import_csv_creates_items_and_links_components
    # Copy fixture CSV to project root as citems.csv
    src = Rails.root.join("test/fixtures/files/citems_test.csv")
    dest = Rails.root.join("citems.csv")
    FileUtils.cp(src, dest)

    Rake::Task["crafting:import_csv"].reenable
    output = capture_io do
      Rake::Task["crafting:import_csv"].invoke
    end

    # Test that both rarities of Test Armor exist
    uncommon = CraftableItem.find_by(name: "Test Armor", rarity: "uncommon")
    rare = CraftableItem.find_by(name: "Test Armor", rarity: "rare")
    assert uncommon, "Uncommon Test Armor should be imported"
    assert rare, "Rare Test Armor should be imported"
    # Test that both rarities of Test Shield exist
    uncommon_shield = CraftableItem.find_by(name: "Test Shield", rarity: "uncommon")
    rare_shield = CraftableItem.find_by(name: "Test Shield", rarity: "rare")
    assert uncommon_shield, "Uncommon Test Shield should be imported"
    assert rare_shield, "Rare Test Shield should be imported"

    # Test that components are linked
    assert_equal 1, uncommon.components.where(component_type: "phial_of_blood").count
    assert_equal 1, rare.components.where(component_type: "phial_of_blood").count
    assert_equal 1, uncommon_shield.components.where(component_type: "plating").count
    assert_equal 1, rare_shield.components.where(component_type: "plating").count

    # Test description fields
    assert_includes uncommon.description, "Requires Attunement"
    assert_includes rare_shield.description, "Requires Attunement"
    assert_includes rare_shield.description, "Monster: Animated"

    # Clean up
    File.delete(dest) if File.exist?(dest)
  end
end
