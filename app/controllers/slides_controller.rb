class SlidesController < ApplicationController
  before_action :set_slide, only: [:show, :destroy]
  before_action :set_album, only: [:new, :index, :create]
  before_action :set_slide_and_album, only: [:edit, :update, :destroy]

  # GET /slides
  def index
    @slides = @album.slides.load.to_a
  end

  # GET /slides/1
  def show    
  end

  # GET /slides/new
  def new
    @slide = Slide.new
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides
  def create
    slide_new_params['photo'].each do |p|
      @photo = p
      @slide = @album.slides.build(photo: @photo)

      if @slide.save        
        flash_message :notice, p.original_filename + ' was successfully uploaded'
      else
        flash_message :error, p.original_filename + ' has some problems: ' + @slide.errors.full_messages.join(' ')
      end      
    end
    redirect_to album_slides_url  
  end
  
  # PATCH/PUT /slides/1
  def update
    if @slide.update(slide_params)
      redirect_to album_slides_url(@album, @slide), notice: 'Slide was successfully updated.'
    else
      flash_message :error, @slide.errors.full_messages.join(" ")
      render action: 'edit'
    end
  end

  # DELETE /slides/1
  def destroy
    if @slide.destroy      
      redirect_to album_slides_url(@album, @slide), notice: 'Slide was successfully destroyed.'
    else
      flash_message :error, @slide.errors.full_messages.join(" ")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_slide_and_album
      @slide = Slide.find(params[:id])
      @album = @slide.album
      @album_id = @slide.album_id
    end

    def set_slide
      @slide = Slide.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def slide_params
      params.require(:slide).permit(:description, :photo)
    end

    def slide_new_params
      params.require(:album_id)
      params[:slide][:photo] ||= []
      params.require(:slide).permit(:description, photo: [])
      
    end
  end
