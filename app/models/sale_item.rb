class SaleItem < ApplicationRecord
    belongs_to :sale
    belongs_to :album
    validates :product_name, :quantity, :price, presence: true
    validates :quantity, numericality: { greater_than: 0 }
    validates :price, numericality: { greater_than_or_equal_to: 0 }
end
