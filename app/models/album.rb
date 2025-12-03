class Album < ApplicationRecord
  # Relaciones
  belongs_to :author
  belongs_to :genre
  has_many :images, dependent: :destroy # Las imágenes se borran si el disco se borra
  has_one :audio, dependent: :destroy # El audio se borra si el disco se borra

  # Atributo: Tipo (Vinilo o CD)
  enum :media_type, {
    vinyl: "Vinilo",
    cd: "CD"
  }

  # Validaciones (para cumplir con los requisitos rgexp, float positivo, etc.)
  validates :name, presence: true, length: { minimum: 2 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_available, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scope para Soft Delete
  default_scope { where(deleted_at: nil) }
end
