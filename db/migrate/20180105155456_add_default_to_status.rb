class AddDefaultToStatus < ActiveRecord::Migration[5.1]
  def change
	  change_column :orders, :status, :boolean, default: :true
  end
end
