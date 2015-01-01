class TrashController < ApplicationController
  before_action :authenticate_user!
  before_action :scope_tenant
	before_action :set_slide, only: [ :show, :destroy, :restore ]

	def index
		@trashed_slides = Slide.only_deleted.order(album_id: :desc).order(:id).load.to_a
	end

	def destroy
		if @trashed_slide.destroy(force: true)
			respond_to do |format|
				format.html { redirect_to trash_index_url, notice: 'Slide was successfully destroyed.' }
				format.js
			end			
		else
			flash_message :error, @trashed_slide.errors.full_messages.join(" ")
			redirect_to trash_index_url
		end
	end

	def destroy_all
		if Slide.only_deleted.destroy_all!
			redirect_to root_path, notice: 'All slides from Trash was successfully destoyed.'
		else
			flash_message :error, @trashed_slide.errors.full_messages.join(" ")
			redirect_to trash_index_url
		end		
	end

	def restore
		if @trashed_slide.restore
			respond_to do |format|
      	format.html { redirect_to trash_index_url, notice: 'Slide was successfully restored.' }
      	format.js
      end
		else
			flash_message :error, @trashed_slide.errors.full_messages.join(" ")
			redirect_to trash_index_url
		end
	end

	def restore_all
		if Slide.only_deleted.restore_all
			redirect_to root_path, notice: 'All slides from Trash was successfuly restored.'
		else
			flash_message :error, @trashed_slide.errors.full_messages.join(" ")
			redirect_to trash_index_url
		end		
	end

	def show
	end

	def set_slide
		@trashed_slide = Slide.only_deleted.find(params[:id])
	end
end
