require "application_system_test_case"

class PartyInventoryTest < ApplicationSystemTestCase
  setup do
    @party = Party.create!(name: "System Test Party")
    @component = Component.create!(monster_type: Component.monster_types.keys.first, component_type: Component.component_types.keys.first)
  end

  test "user can view, filter, and add a component to party inventory" do
    visit party_party_components_path(@party)
    assert_text "Inventory for"
    click_link "Add Component"
    assert_text "Available Components"
    # Filter by monster type
    select @component.monster_type.titleize, from: "monster_type"
    # Filter by component type
    select @component.component_type.titleize, from: "component_type"
    # Add the component (use more specific selector for Add button)
    within(:xpath, "//tr[td[contains(text(), '#{@component.display_name}')]]") do
      find("button[data-action='click->modal#open']").click
    end
    # Modal should appear
    assert_selector "#add-form-modal", visible: true
    fill_in "Quantity", with: 2
    find("#add-form-modal button[type='submit']").click
    # Should redirect to inventory and show the new component
    assert_text @component.display_name
    assert_text "2"
  end

  test "user can remove a component from party inventory" do
    @party_component = @party.party_components.create!(component: @component, quantity: 1)
    visit party_party_components_path(@party)
    assert_text @component.display_name
    # Remove the component (JS confirm auto-accepted)
    within("tr[data-expandable-row-component-id-value='#{@component.id}']") do
      click_button "Remove"
    end
    # Should no longer see the component in inventory (check after row is gone)
    assert_no_text @component.display_name
  end
end
