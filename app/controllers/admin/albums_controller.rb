class Admin::AlbumsController < ApplicationController
  layout "admin"
  before_action :set_album, only: %i[ show edit update destroy disabled_enabled ]
  before_action :set_album_context, only: %i[ edit new create update]

  # GET /albums or /albums.json
  def index
    @albums = Album.unscope(where: :deleted_at).all
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to admin_album_path(@album), notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to admin_album_path(@album), notice: "Album was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def disabled_enabled
    @album.disabled_enabled
    redirect_to admin_albums_path(@album), notice: "Album fue
correctamente habilitado/deshabilitado."
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    @album.destroy!

    respond_to do |format|
      format.html { redirect_to admin_albums_path, notice: "Album was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.unscope(where: :deleted_at).find(params[:id])
    end

    def set_album_context
      @authors = Author.all
      @genres = Genre.all
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.expect(album: [ :name, :description, :unit_price, :stock_available, :genre_id, :year, :media_type, :condition_is_new, :author_id, :deleted_at ])
    end
end
