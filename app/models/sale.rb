class Sale < ApplicationRecord
  belongs_to :user
  validates :sale_date, :buyer_name, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
end
