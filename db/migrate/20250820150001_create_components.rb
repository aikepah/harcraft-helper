class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.string :monster_type
      t.string :component_type
      t.integer :dc
      t.boolean :volatile, default: false, null: false
      t.boolean :edible, default: false, null: false
      t.text :note
      t.timestamps
    end
  end
end
