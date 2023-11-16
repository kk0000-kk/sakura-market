class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.text :description
      t.boolean :disabled
      t.integer :position

      t.timestamps
    end
  end
end
