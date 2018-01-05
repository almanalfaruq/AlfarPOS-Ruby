class OrdersController < ApplicationController

	def show
		@order = Order.find_by_code(params[:code])
	end

	def new
		@order_id = params[:order_id]
		@user = current_user
		@order = Order.new(code: @order_id, user: @user)
		respond_to do |f|
			if @order.save
				f.json { render json: @order, status: :created }
			else
				f.json { render json: @order.errors, status: :unprocessable_entity }
			end
		end
	end

end
