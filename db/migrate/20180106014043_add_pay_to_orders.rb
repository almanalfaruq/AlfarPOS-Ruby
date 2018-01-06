class AddPayToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :pay, :decimal, precision: 12, scale: 2, null: false, default: 0.00
  end
end
