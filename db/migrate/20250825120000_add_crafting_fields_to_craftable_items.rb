class AddCraftingFieldsToCraftableItems < ActiveRecord::Migration[8.0]
  def change
    add_column :craftable_items, :manufacturing_dc, :integer
    add_column :craftable_items, :enchanting_dc, :integer
    add_column :craftable_items, :tool, :string
    add_column :craftable_items, :time_required, :string
    add_column :craftable_items, :material_cost, :integer
    add_column :craftable_items, :auxiliary_equipment, :string
  end
end
