class OrderPdf < Prawn::Document
	include ActionView::Helpers::NumberHelper

	def initialize(order, order_details)
		@order = order
		@order_details = order_details
		line_items_height = 14*@order_details.size + 56
		header_height = 170
		body_height = 20 + 56
		if line_items_height > body_height
			body_height = line_items_height
		end
		min_height = header_height + body_height 
		super(page_size: [min_height, 180], page_layout: :landscape, top_margin: 0.0, left_margin: 18.0, right_margin: 2.5, bottom_margin: 7.0)
		font "Courier"
		header
		table_items
		footer
	end

	def header 
		text "TOKO ALFAR", align: :center, style: :bold
		text "Ketaon Utara RT 7 RW 1, Banyudono, Boyolali", align: :center, size: 9
		text "(0276) 3283720", align: :center, size: 9
		move_down 2
		text "ID: #{@order.code}", align: :center, size: 8.5
	end

	def table_items
		header = [["DESKRIPSI", "", "", ""],["QTY", "SAT", "HARGA", "SUBTOTAL"]]
		move_down 5
		table(header, position: :center, width: bounds.width) do
			cells.size = 7
			row(0).borders = [:top]
			row(0).border_lines = [:dashed, :dashed, :dashed, :dashed] 
			row(0).padding = [0,0,4,0]
			row(1).borders = [:bottom]
			row(1).border_lines = [:dashed, :dashed, :dashed, :dashed]
			row(1).column(0).align = :right
			row(1).column(3).align = :right
			row(1).column(0).padding = [0,4,4,0]
			row(1).column(1).padding = [0,0,4,7]
			row(1).column(2).padding = [0,0,4,0]
			row(1).column(3).padding = [0,0,4,0]
		end
		items =  []
		@order_details.each do |o|
			p = [o.item.name]
			items.push(p)
			p = [o.qty, o.item.unit, price_without_rp(o.item.price), price_without_rp(o.subtotal)]
			items.push(p)
		end
		table(items, position: :center, width: bounds.width) do
			cells.size = 7
			row(items.size-1).borders = [:bottom]
			row(items.size-1).border_lines = [:dashed, :dashed, :dashed, :dashed]
			items.each_with_index do |val, index|
				unless index == items.size-1
					row(index).border_width = 0
				end
				if index%2 == 1
					row(index).column(0).align = :right
					row(index).column(0).padding = [0,33,4,0]
					row(index).column(1).padding = [0,0,4,-23]
					row(index).column(2).padding = [0,0,4,-5]
					row(index).column(3).padding = [0,0,4,0]
					row(index).column(3).align = :right
				else
					row(index).padding = [0,0,0,0]
				end
			end
		end
	end

	def footer
		data_footer = [["Total:", "#{price_with_rp(@order.total)}"], ["Bayar:","#{price_with_rp(@order.pay)}"], ["Kembali:", "#{price_with_rp(return_cash)}"]]
		table(data_footer, position: :center, width: bounds.width) do
			cells.size = 7
			cells.padding = [0,0,4,0]
			column(0).align = :left
			column(1).align = :right
			row(0).border_width = 0
			row(1).border_width = 0
			row(2).border_lines = [:dashed, :dashed, :dashed, :dashed]
			row(2).borders = [:bottom]
		end
		move_down 15
		text "Barang Yang Sudah Dibeli Tidak Dapat Dikembalikan", size: 8.5, align: :center
		move_down 2
		text "TERIMAKASIH ATAS KUNJUNGAN ANDA", align: :center, size: 9.5
		text "#{@order.user.name} | #{@order.created_at.strftime("%d/%b/%Y - %H:%M:%S")}", size: 8, align: :center
	end

	private

	def price_without_rp(p)
		number_with_delimiter(p, delimiter: ".")
	end

	def price_with_rp(p)
		number_to_currency(p, unit: "Rp", separator: ",", delimiter: ".", format: "%u %n")
	end

	def return_cash
		@order.pay - @order.total		
	end
end
