class Sale < ApplicationRecord
  belongs_to :user
  has_many :sale_items, dependent: :destroy
  validates :sale_items, length: { minimum: 1 }
  validates :sale_date, :buyer_name, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :buyer_id, presence: true, format: { with: /\A\d{7,8}\z/, message: "debe tener 7 u 8 dígitos" }
end
