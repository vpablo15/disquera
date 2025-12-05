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
    # 1. Inicializa el Album
    @album = Album.new
    @album.images.build(is_cover: true, title: "Portada del Álbum")
    @album.build_audio
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums or /albums.json
  def create

    Rails.logger.debug "Album Params Recibidos: #{album_params.inspect}"
    @album = Album.new(album_params.except(:photo, :clip))
    cover_file = album_params[:photo]
    audio_file = album_params[:clip]

    if @album.save
      if cover_file.present?
        @album.images.create!(
          title: "#{@album.name} Cover",
          is_cover: cover_file[:is_cover],
        ) do |image|
          # Aquí pasamos el objeto UploadedFile
          image.photo.attach(cover_file[:photo])
        end
        flash[:notice] = "Portada adjuntada exitosamente."
      end
      # --- B. Adjuntar Audio Único ---
      if audio_file.present?
        @album.create_audio! do |audio| audio.clip.attach(audio_file[:clip])
        end
        flash[:notice] = (flash[:notice] || "") + " Audio adjuntado exitosamente."
      end
      redirect_to @album, notice: 'Álbum creado exitosamente.'
    else # Si el álbum no se guarda (ej. por validaciones de `name`), renderiza el formulario
      render :new, status: :unprocessable_entity
    end
  rescue StandardError => e
    # Captura errores en la subida o creación
    flash.now[:alert] = "Error al procesar los archivos: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format| if @album.update(album_params)
      format.html { redirect_to admin_album_path(@album), notice: "Album was successfully updated.", status: :see_other }
      format.json { render :show, status: :ok, location: @album }
    else format.html { render :edit, status: :unprocessable_entity }
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

    respond_to do |format| format.html { redirect_to admin_albums_path, notice: "Album was successfully destroyed.", status: :see_other }
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
    params.require(:album).permit(
      :name,
      :description,
      :unit_price,
      :stock_available,
      :genre_id,
      :year,
      :media_type,
      :condition_is_new,
      :author_id,
      :deleted_at,

      # Permite el hash anidado 'photo' y los campos permitidos dentro de él
      photo: [:photo, :is_cover, :title],

      # Permite el hash anidado 'clip' y el campo permitido dentro de él
      clip: [:clip]
    )
  end

end