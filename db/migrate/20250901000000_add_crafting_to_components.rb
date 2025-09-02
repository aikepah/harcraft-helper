class AddCraftingToComponents < ActiveRecord::Migration[8.0]
  def change
    add_column :components, :crafting, :boolean, default: false, null: false
  end
end
