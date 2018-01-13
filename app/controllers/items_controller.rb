class ItemsController < ApplicationController
	autocomplete :item, :name, extra_data: [:code], full: :true

	def index
		@items = Item.all

		respond_to do |format|
			format.json { render json: @items }
		end
	end

	def show
		@item = Item.find_by_code(params[:id])

		respond_to do |format|
			format.json { render json: @item }
		end
	end
end

