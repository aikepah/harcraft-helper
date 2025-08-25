class CreateCraftableItemComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :craftable_item_components do |t|
      t.references :craftable_item, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
