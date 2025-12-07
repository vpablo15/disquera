class Author < ApplicationRecord
  has_many :albums
  validates :full_name, presence: true, uniqueness: true
end
