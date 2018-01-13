class AddBuyPriceToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :buy_price, :decimal, precision: 10, scale: 2, null: false, default: 0.00
  end
end
