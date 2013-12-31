class SlidesController < ApplicationController
  before_action :set_slide, only: [:show, :edit, :update, :destroy]
  before_action :set_album, only: [:index, :create, :update, :destroy]


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
    
    # @slide = Slide.new(slide_new_params)
    @slide = @album.slides.build(slide_new_params)

    if @slide.save
      redirect_to @slide, notice: 'Slide was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /slides/1
  def update
    if @slide.update(slide_params)
      redirect_to [@album, @slide], notice: 'Slide was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /slides/1
  def destroy
    @slide.destroy
    redirect_to album_slides_url, notice: 'Slide was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:album_id])
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
      params.require(:slide).permit(:description, :photo)
    end
end
