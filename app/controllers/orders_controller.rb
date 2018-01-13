class OrdersController < ApplicationController
  def show
    @order = Order.find_by_code(params[:code])
    @order_details = OrderDetail.where(order: @order)
    respond_to do |f|
      f.json { render json: @order }
      f.pdf do
        pdf = OrderPdf.new(@order, @order_details)
        send_data pdf.render, filename: 'receipt.pdf', type: 'application/pdf', disposition: 'inline'
      end
      f.html { redirect_to root_path }
    end
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
