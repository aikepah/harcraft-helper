require "application_system_test_case"

class PartyInventoryCraftableItemsTest < ApplicationSystemTestCase
  setup do
    @party = Party.create!(name: "Craftable Test Party")
    @component = components(:dragon_bone)
    @party_component = @party.party_components.create!(component: @component, quantity: 1)
    # Ensure the craftable item and link exist
    @craftable_item = craftable_items(:dragon_sword)
    CraftableItemComponent.create!(craftable_item: @craftable_item, component: @component, quantity: 2)
  end

  test "user can expand a component and see craftable items" do
    visit party_party_components_path(@party)
    assert_text @component.display_name
    # Find the expand button for this component and click it using data attribute
    within("tr[data-expandable-row-component-id-value='#{@component.id}']") do
      find("button.expand-btn").click
    end
    # The craftable item should now be visible in the expanded section
    assert_text @craftable_item.name
    assert_text @craftable_item.rarity.titleize
    assert_text @craftable_item.item_type
    assert_text @craftable_item.material_cost.to_s, exact: false
  end
end
