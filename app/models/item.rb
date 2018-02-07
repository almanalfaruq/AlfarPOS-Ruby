class Item < ApplicationRecord
  has_many :order_details
  has_many :orders, through: :order_details

  # Import excel file
  def self.import(file)
	# Open excel file using Roo gem then set the default sheet to first sheet
    xlsx = Roo::Spreadsheet.open(file.path)
    xlsx.default_sheet = xlsx.sheets.first
	# Querying each row except the header
    xlsx.each_row_streaming(offset: 1) do |row|
      next if find_code(row).nil? || find_price(row).zero? # Skip if code is null and price is zero
      item = find_by_code(find_code(row))
	  # Check if item exists, if not create new item, if exists change the attribute
      if item.nil?
        create(code: find_code(row), name: find_name(row), price: find_price(row), qty: find_qty(row),
               unit: find_unit(row), category: find_category(row), buy_price: find_buy_price(row))
      else
        item.name = find_name(row)
        item.price = find_price(row)
        item.qty = find_qty(row)
        item.unit = find_unit(row)
        item.buy_price = find_buy_price(row)
        item.category = find_category(row)
        item.save!
      end
    end
  end

  # Find the item's code in the excel row
  def self.find_code(row)
    cell = row.values_at(0)[0]
    if cell.value.nil?
      nil
    else
      cell.value.to_i.to_s
    end
  end

  # Find the item's name in the excel row
  def self.find_name(row)
    cell = row.values_at(1)[0]
    cell.value
  end

  # Find the item's price in the excel row
  def self.find_price(row)
    cell = row.values_at(2)[0]
    if cell.value.nil?
      0
    else
      cell.value.to_i
    end
  end

  # Find the item's qty in the excel row
  def self.find_qty(row)
    cell = row.values_at(3)[0]
    if cell.value.nil?
      10
    else
      cell.value.to_i
    end
  end

  # Find the item's category in the excel row
  def self.find_category(row)
    cell = row.values_at(4)[0]
    if cell.value.nil?
      ''
    else
      cell.value
    end
  end

  # Find the item's buy price in the excel row
  def self.find_buy_price(row)
    cell = row.values_at(5)[0]
    if cell.value.nil?
      0
    else
      cell.value.to_i
    end
  end

  # Find the item's unit in the excel row
  def self.find_unit(row)
    cell = row.values_at(6)[0]
    if cell.value.nil?
      'Pcs'
    else
	  cell.value.to_s.titleize
    end
  end
end
