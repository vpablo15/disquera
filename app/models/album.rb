class Album < ApplicationRecord
  # Relaciones
  belongs_to :author
  belongs_to :genre
  has_many :images, dependent: :destroy # Las imágenes se borran si el disco se borra
  has_one :audio, dependent: :destroy # El audio se borra si el disco se borra
  accepts_nested_attributes_for :images,
    allow_destroy: true,
    reject_if: :all_blank

  enum :media_type, {
    vinyl: "Vinilo",
    cd: "CD"
  }

  # Validaciones (para cumplir con los requisitos rgexp, float positivo, etc.)
  validates :name, presence: true, length: { minimum: 2 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_available, :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def disabled_enabled
    if self.deleted_at.nil?
      update(deleted_at: Time.current, stock_available: 0)
    else
      update(deleted_at: nil)
    end
  end

  # Scope para Soft Delete
  default_scope { where(deleted_at: nil) }
end
