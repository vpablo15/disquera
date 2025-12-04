class Album < ApplicationRecord
  # Relaciones
  belongs_to :author
  belongs_to :genre
  has_many :images, dependent: :destroy # Las imágenes se borran si el disco se borra
  has_one :audio, dependent: :destroy # El audio se borra si el disco se borra
  has_many :sale_items

  # Atributo: Tipo (Vinilo o CD)
  enum :media_type, {
    vinyl: "Vinilo",
    cd: "CD"
  }

  # Validaciones (para cumplir con los requisitos rgexp, float positivo, etc.)
  validates :name, presence: true, length: { minimum: 2 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_available, :year, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scope para Soft Delete
  default_scope { where(deleted_at: nil) }

  def related_albums
    # Definir la consulta base para el Autor
    by_author = Album.where(author_id: self.author_id)
                     .where.not(id: self.id)
    # Definir la consulta base para el Género
    by_genre = Album.where(genre_id: self.genre_id)
                    .where.not(id: self.id)

    # Combinar ambas consultas usando OR y asegurar resultados únicos (distinct)
    by_author.or(by_genre).distinct.limit(3)
  end
end
