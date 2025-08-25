class CraftableItemComponent < ApplicationRecord
  belongs_to :craftable_item
  belongs_to :component
end
