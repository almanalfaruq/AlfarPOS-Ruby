class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def dashboard
    @orders = Order.all
  end

  def restore; end

  def item
    @items = Item.all
  end

  def user
    @users = User.all
  end

  def history
    @orders = Order.all
  end

  private

  def check_admin
    redirect_to root_path unless current_user.has_role? :admin
  end
end
