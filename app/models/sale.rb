class Sale < ApplicationRecord
  belongs_to :user
  has_many :sale_items, dependent: :destroy
  validates :sale_date, :buyer_name, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
end
