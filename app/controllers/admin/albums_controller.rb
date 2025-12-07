class Admin::AlbumsController < ApplicationController
  layout "admin"
  before_action :set_album, only: %i[ show edit update destroy disabled_enabled ]
  before_action :set_album_context, only: %i[ edit new create update]
  before_action :authenticate_user!
  load_and_authorize_resource class: "Album", except: %i[ create]
  authorize_resource class: "Album", only: %i[ create ]

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
        @album.images.create!(title: "#{@album.name} Cover", is_cover: true,) do |image| # Aquí pasamos el objeto UploadedFile
          image.photo.attach(cover_file[:photo])
        end
      end
      # --- B. Adjuntar Audio Único ---
      if audio_file.present?
        @album.create_audio! do |audio| audio.clip.attach(audio_file[:clip])
        end
      end
      redirect_to admin_album_path(@album), notice: 'Álbum creado exitosamente.'
    else render :new, status: :unprocessable_entity
    end
  rescue StandardError => e
    flash.now[:alert] = "Error al procesar los archivos: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  # PATCH/PUT /albums/1
  def update
    # 1. Separar los parámetros de los archivos adjuntos
    cover_file = album_params[:photo]
    audio_file = album_params[:clip]

    if @album.update(album_params.except(:photo, :clip))
      if cover_file.present?
        @album.images.create!(title: "#{@album.name} Portada", is_cover: false) do |image| image.photo.attach(cover_file[:photo])
        end
      end

      if audio_file.present?
        if @album.audio.present?
          @album.audio.clip.purge
          @album.audio.clip.attach(audio_file[:clip])
        else @album.create_audio! do |audio| audio.clip.attach(audio_file[:clip])
        end
        end
      end
      respond_to do |format| format.html { redirect_to admin_album_path(@album), notice: "Álbum y archivos actualizados con éxito." }
      format.json { render :show, status: :ok, location: @album }
      end
    else # Si la actualización de atributos básicos falla
      respond_to do |format| format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    flash.now[:alert] = "Error al procesar los archivos: #{e.message}"
    render :edit, status: :unprocessable_entity
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

  def set_single_cover_image_status(permitted_params, cover_id)
    processed_params = permitted_params.dup
    cover_id_to_match = cover_id.to_s

    if cover_id_to_match.present? && processed_params[:images_attributes].present?
      processed_params[:images_attributes].each do |index, img|
        image_id = img[:id].to_s
        if image_id == cover_id_to_match
          img[:is_cover] = true
        else
          img[:is_cover] = false
        end
      end
    end
    processed_params
  end

  def album_params
    Rails.logger.debug "Album Params Recibidos: #{params.inspect}"

    # 1. CORRECCIÓN: Requerir el hash :album
    p = params.require(:album).permit(
      :name, :description, :unit_price, :stock_available, :genre_id, :year,
      :media_type, :condition_is_new, :author_id, :deleted_at,

      photo: [ :photo ],
      clip: [ :clip ],
      images_attributes: [ :id, :is_cover, :_destroy ]
    )
    set_single_cover_image_status(p, params[:cover_image_id])
  end

end