class ItemsController < ApplicationController
  autocomplete :item, :name, extra_data: [:code], full: :true

  def index
    @items = Item.all

    respond_to do |format|
      format.json { render json: @items }
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    respond_to do |format|
	  begin
		@item.save!  
	  rescue ActiveRecord::ActiveRecordError => e 
        format.json do
          render json: {
			  error: e.message
          }, status: :unprocessable_entity
		end
	  end
	  format.json { render json: @item, status: :created }
    end
  end

  def show
    @item = Item.find_by_code(params[:id])

    respond_to do |format|
      format.json { render json: @item }
    end
  end

  def import
    Item.import(params[:file])

    redirect_to admin_dashboard_path, notice: 'Items imported.'
  end

  private

  def item_params
    params.require(:item).permit(:code, :name, :price, :qty, :category, :buy_price, :unit)
  end
end
