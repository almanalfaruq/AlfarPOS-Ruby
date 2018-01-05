class CreateOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :order_details do |t|
      t.references :item, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :qty,									null: false, default: 1
      t.decimal :subtotal, precision: 10, scale: 2,		null: false, default: 0.00

      t.timestamps
    end
  end
end
