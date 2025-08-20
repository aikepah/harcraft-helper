class CreateParties < ActiveRecord::Migration[8.0]
  def change
    create_table :parties do |t|
      t.string :name
      t.text :notes
      t.timestamps
    end
  end
end
