class Image < ApplicationRecord
  # Relación con el disco
  belongs_to :album
  # Active Storage: Asocia el modelo con un archivo adjunto
  has_one_attached :photo
  # Validaciones (Opcional, pero recomendado)
  validates :title, length: { maximum: 100 }, allow_blank: true
end
