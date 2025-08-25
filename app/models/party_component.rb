class PartyComponent < ApplicationRecord
  belongs_to :party
  belongs_to :component
  # Store quantity and metatag as before
end
