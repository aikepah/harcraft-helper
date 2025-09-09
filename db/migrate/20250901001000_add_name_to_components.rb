class AddNameToComponents < ActiveRecord::Migration[8.0]
  def change
    add_column :components, :name, :string
  end
end
