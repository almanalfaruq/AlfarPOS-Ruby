class Item < ApplicationRecord
  has_many :order_details
  has_many :orders, through: :order_details

  def self.import(file)
    xlsx = Roo::Spreadsheet.open(file.path)
    xlsx.default_sheet = xlsx.sheets.first
    xlsx.each_row_streaming(offset: 1, max_rows: 4) do |row|
      item = find_by_code(find_code(row))
      if item.nil?
        create(code: find_code(row), name: find_name(row), price: find_price(row), qty: find_qty(row), unit: find_unit(row))
      else
        item.name = find_name(row)
        item.price = find_price(row)
        item.qty = find_qty(row)
        item.unit = find_unit(row)
        item.save!
      end
    end
  end

  def self.find_code(row)
    cell = row.values_at(0)[0]
    cell.value.to_i.to_s
  end

  def self.find_name(row)
    cell = row.values_at(1)[0]
    cell.value
  end

  def self.find_price(row)
    cell = row.values_at(5)[0]
    cell.value.to_i
  end

  def self.find_qty(row)
    cell = row.values_at(3)[0]
    if cell.value.nil?
      10
    else
      cell.value.to_i
    end
  end

  def self.find_unit(row)
    cell = row.values_at(7)[0]
    if cell.value.nil?
      'Pcs'
    else
      cell.value
    end
  end
end
