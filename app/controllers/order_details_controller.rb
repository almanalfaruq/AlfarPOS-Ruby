class OrderDetailsController < ApplicationController

	def new
		@order = Order.find_by_code(params[:order_id])
		@items = params[:items]
		@quantities = params[:qtys]
		@total = 0
		@items.each_with_index do |val, index|
			@item = Item.find_by_code(val)
			@subtotal = @quantities[index].to_i*@item.price
			@item.qty -= @quantities[index].to_i
			@item.save
			@total += @subtotal
			OrderDetail.create(order: @order, item: @item, qty: @quantities[index].to_i, subtotal: @subtotal)
		end
		@order.total = @total
		respond_to do |f|
			if @order.save
				f.json { render json: @order, status: :accepted }
			else
				f.json { render json: @order.errors, status: :unprocessable_entity }
			end
		end
	end

end
