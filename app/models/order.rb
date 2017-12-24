class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details
  has_many :items, through: :order_details
end
