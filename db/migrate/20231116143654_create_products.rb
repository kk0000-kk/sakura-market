class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ''
      t.integer :price, null: false
      t.text :description
      t.boolean :disabled, null: false, default: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
