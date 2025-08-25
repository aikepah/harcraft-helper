class CreatePartyComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :party_components do |t|
      t.references :party, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.string :metatag
      t.timestamps
    end
  end
end
