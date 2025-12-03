class AlbumsController < ApplicationController
  layout "front"
  before_action :set_album, only: %i[ show ]

  # GET /albums or /albums.json
  def index
    @filters = params[:filters] || {}
    @albums = filter(Album.all)
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params.expect(:id))
    end

    def filter(collection)
      if @filters[:name].present?
        collection = collection.where("name LIKE ?", "%#{@filters[:name].strip}%")
      end

      if @filters[:author_name].present?
        collection = collection.joins(:author).where("authors.full_name LIKE ?", "%#{@filters[:author_name].strip}%")
      end

      if @filters[:genre_name].present?
        collection = collection.joins(:genre).where("genres.name LIKE ?", "%#{@filters[:genre_name]}%")
      end

      if @filters[:year].present?
        collection = collection.where(year: @filters[:year])
      end

      if @filters[:media_type].present?
        collection = collection.where(media_type: @filters[:media_type])
      end
      # El valor del filtro debe ser 'true' o 'false' como string
      if @filters[:condition].present?
        # Convertir el string 'true'/'false' a un booleano
        is_new = @filters[:condition] == "true"
        collection = collection.where(condition_is_new: is_new)
      end

      collection
    end
end
