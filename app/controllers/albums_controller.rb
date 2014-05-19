class AlbumsController < ApplicationController
  before_action :authenticate_user!
  before_action :scope_tenant
  before_action :set_album, only: [:edit, :update, :destroy]

  # GET /albums
  def index
    @albums = Album.all
  end

  # GET /albums/new
  def new
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums
  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to @album, notice: 'Album was successfully created.'
    else
      flash_message :error, @album.errors.full_messages.join(" ")
      render action: 'new'
    end
  end
  # /PUT /albums/1
  def update
    if @album.update(album_params)
      redirect_to @album, notice: 'Album was successfully updated.'
    else
      flash_message :error, @album.errors.full_messages.join(" ")
      render action: 'edit'
    end
  end

  # DELETE /albums/1
  def destroy
    if @album.destroy      
      respond_to do |format|
        format.html { redirect_to albums_url, notice: 'Album was successfully destroyed.' }
        format.js
      end
    else
      flash_message :error, @album.errors.full_messages.join(" ")
      redirect_to albums_url      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def album_params
      params.require(:album).permit(:name)
    end   
  end
