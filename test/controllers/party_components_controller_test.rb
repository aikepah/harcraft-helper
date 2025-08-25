require "test_helper"

class PartyComponentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @party = Party.create!(name: "Test Party")
  @component = Component.create!(monster_type: Component.monster_types.keys.first, component_type: Component.component_types.keys.first)
    @party_component = @party.party_components.create!(component: @component)
  end

  test "should get index" do
    get party_party_components_url(@party)
    assert_response :success
  end

  test "should get new" do
    get new_party_party_component_url(@party)
    assert_response :success
  end

  test "should create party_component" do
    assert_difference("PartyComponent.count") do
      post party_party_components_url(@party), params: { party_component: { component_id: @component.id } }
    end
    assert_redirected_to party_party_components_url(@party)
  end

  test "should destroy party_component" do
    assert_difference("PartyComponent.count", -1) do
      delete party_party_component_url(@party, @party_component)
    end
    assert_redirected_to party_party_components_url(@party)
  end
end
