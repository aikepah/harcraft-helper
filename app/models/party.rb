class Party < ApplicationRecord
  has_many :party_components, dependent: :destroy
  has_many :components, through: :party_components
end
