
# Represents an item that can be crafted, including all recipe/crafting info.
class CraftableItem < ApplicationRecord
  has_many :craftable_item_components, dependent: :destroy
  has_many :components, through: :craftable_item_components


  # Example fields for crafting recipe
  # :manufacturing_dc, :enchanting_dc, :tool, :time_required, :material_cost, :auxiliary_equipment
end
