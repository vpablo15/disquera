class Audio < ApplicationRecord
  belongs_to :album
  has_one_attached :clip
end
