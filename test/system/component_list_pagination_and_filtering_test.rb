require "application_system_test_case"

class ComponentListPaginationAndFilteringTest < ApplicationSystemTestCase
  setup do
    @party = Party.create!(name: "Pagination Test Party")
    # Create enough components to require pagination
    25.times do |i|
      Component.create!(monster_type: Component.monster_types.keys.first, component_type: Component.component_types.keys.first, name: "Component#{i}")
    end
  end

  test "pagination preserves filters and filters reset page" do
    visit new_party_party_component_path(@party)
    assert_text "Available Components"
    # Go to page 2
    click_link "2"
    assert_current_path(/page=2/)
    # Apply a filter (should reset to page 1)
    select Component.monster_types.keys.first.titleize, from: "monster_type"
    assert_no_current_path(/page=2/)
    # Go to page 2 again with filter
    click_link "2"
    assert_current_path(/page=2/)
    # Remove filter, should reset to page 1
    select "Filter by Monster Type", from: "monster_type"
    assert_no_current_path(/page=2/)
  end

  test "pagination and filters persist together" do
    visit new_party_party_component_path(@party)
    select Component.monster_types.keys.first.titleize, from: "monster_type"
    click_link "2"
    assert_current_path(/monster_type=.*&page=2/)
    # Now change component type filter, should reset to page 1 but keep monster_type
    select Component.component_types.keys.first.titleize, from: "component_type"
    assert_current_path(/monster_type=.*&component_type=.*(?!page=2)/)
  end
end
