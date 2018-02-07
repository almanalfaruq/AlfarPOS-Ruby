class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def dashboard
    check_user
	@orders = Order.where("created_at >= ?", Time.zone.now.beginning_of_day)
	@total = 0
	@orders.each do |o|
		@total += @orders.total
	end
  end

  def restore; end

  def item
    @items = Item.all
    @item = Item.new
  end

  def user
    check_user
    @users = User.all
  end

  def order
    check_user
    @orders = Order.all
    @order_details = OrderDetail.all
  end

  def history
    check_user
    @histories = History.all
  end

  def backup
    @items = Item.all
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Dispotition'] = 'attachment; filename="Data Barang AlfarPOS"'
      end
    end
  end

  private

  def check_admin
    redirect_to root_path if current_user.has_role? :cashier
  end

  def check_user
    redirect_to admin_item_path if current_user.has_role? :manager
  end
end
