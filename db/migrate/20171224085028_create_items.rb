class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :code,								null: false, default: ""
      t.string :name,								null: false, default: ""
      t.decimal :price, precision: 10, scale: 2,	null: false, default: 0.00
      t.integer :qty,								null: false, default: 0
      t.string :unit,								null: false, default: "Pcs"

      t.timestamps
    end

	add_index :items, :code, 		unique: true
  end
end
