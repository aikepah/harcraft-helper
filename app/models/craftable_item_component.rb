
# Join model for required components in a recipe, with quantity.
class CraftableItemComponent < ApplicationRecord
  belongs_to :craftable_item
  belongs_to :component
end
