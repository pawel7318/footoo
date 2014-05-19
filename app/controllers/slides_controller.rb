class SlidesController < ApplicationController
  before_action :authenticate_user!
  before_action :scope_tenant
  before_action :set_slide, only: [:show]
  before_action :set_album, only: [:new, :index, :create]
  before_action :set_slide_and_album, only: [:edit, :update]
  before_action :set_for_destroy, only: [:destroy]
  before_action :set_for_move, only: [:move]
  # GET /slides
  def index
    @slides = @album.slides.load.to_a
    @other_albums = Album.where('id != :id', id: @album.id)
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
      
      @slide['description'] = slide_new_params['description']

      if @slide.save        
        flash_message :notice, p.original_filename + ' was successfully uploaded'
      else
        flash_message :error, p.original_filename + ' has some problems: ' + @slide.errors.full_messages.join(' ')
      end      
    end
    redirect_to album_slides_path  
  end
  
  # PATCH/PUT /slides/1
  def update
    if @slide.update(slide_params)
      redirect_to album_slides_path(@album), notice: 'Slide was successfully updated.'
    else
      flash_message :error, @slide.errors.full_messages.join(" ")
      render action: 'edit'
    end
  end

  # DELETE /slides/1
  def destroy
    @destroyed_slides = []
    @ids.each do |id|
      begin          
        @destroyed_slides << Slide.destroy(id)                
      rescue ActiveRecord::RecordNotFound          
        flash_message :error, "Cannot trash #{id} slide."        
      end
    end
    flash_message :notice, ActionController::Base.helpers.pluralize(@destroyed_slides.length, 'slide') + ' was successfully trashed.' if (@destroyed_slides.length > 0)
    respond_to do |format|
      format.html { redirect_to album_slides_path(@album) }
      format.js
    end     
  end

  def move
    @moved_slides = []
    @ids.each do |id|
      begin
        @slide = Slide.find(id.to_i)
        @slide.album_id = @new_album_id
        @slide.save
        @moved_slides << @slide
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
        flash_message :error, "Cannot move #{id} slide."
      end
    end

    #flash_message :notice, ActionController::Base.helpers.pluralize(@destroyed_slides.length, 'slide') + ' was .' if (@moved_slides.length > 0)
    respond_to do |format|
      #format.html { redirect_to album_slides_path(@album) }
      format.js
    end     
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:album_id])
    end

    def set_for_destroy      
      @ids = params.require(:ids)
      @ids = [@ids] unless @ids.kind_of?(Array)
      @album = params.require(:album_id)      
    end

    def set_for_move
      @ids = params.require(:ids)
      @ids = [@ids] unless @ids.kind_of?(Array)
      @new_album_id = params.require(:new_album_id)
    end

    def set_slide_and_album
      @slide = Slide.find(params[:id])
      @album = @slide.album
    end

    def set_slide
      @slide = Slide.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def slide_params
      params.require(:slide).permit(:description)
    end

    def slide_new_params
      params.require(:album_id)
      params[:slide][:photo] ||= []
      params.require(:slide).permit(:description, photo: [])
    end
  end

