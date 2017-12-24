class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.string :code,								null: false, default: ""
      t.string :customer,							null: false, default: ""
      t.decimal :total, precision: 12, scale: 2, 	null: false, default: 0.00

      t.timestamps
    end

	add_index :orders, :code,						unique: true
  end
end
