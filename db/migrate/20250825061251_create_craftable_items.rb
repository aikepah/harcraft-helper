class CreateCraftableItems < ActiveRecord::Migration[8.0]
  def change
    create_table :craftable_items do |t|
      t.string :name
      t.text :description
      t.string :item_type
      t.string :rarity
      t.string :essence_level
      t.string :crafting_method
      t.string :source

      t.timestamps
    end
  end
end
