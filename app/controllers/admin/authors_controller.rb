class Admin::AuthorsController < ApplicationController
  layout "admin"
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  load_and_authorize_resource class: "Author"

  # GET /authors or /authors.json
  def index
    @authors = Author.all
  end

  # GET /authors/1 or /authors/1.json
  def show
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors or /authors.json
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to admin_author_path(@author), notice: "Author was successfully created." }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to admin_author_path(@author), notice: "Author was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    if @author.albums.any?
      respond_to do |format|
        format.html {
          redirect_to admin_authors_path,
          alert: "No se puede eliminar el autor '#{@author.full_name}' porque tiene álbumes asociados. Elimine los álbumes primero."
        }
        format.json { head :conflict }
      end
    else
      @author.destroy!

      respond_to do |format|
        format.html { redirect_to admin_authors_path, notice: "Author was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.expect(author: [ :full_name ])
    end
end
