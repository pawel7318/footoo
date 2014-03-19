class TrashController < ApplicationController
	before_action :set_slide, only: [ :show, :destroy, :restore ]

	def index
		@trashed_slides = Slide.only_deleted.order(album_id: :desc).order(:id).load.to_a
	end

	def destroy
		if @trashed_slide.destroy(force: true)
			redirect_to trash_index_url, notice: 'Slide was successfully destroyed.'
		else
			flash_message :error, @slide.errors.full_messages.join(" ")
		end
	end

	def destroy_all
		if Slide.only_deleted.destroy_all!
			redirect_to root_path, notice: 'All slides from Trash was successfully destoyed.'
		else
			flash_message :error, @slide.errors.full_messages.join(" ")
		end		
	end

	def restore
		if @trashed_slide.restore
			redirect_to trash_index_url, notice: 'Slide was successfully restored.'
		else
			flash_message :error, @slide.errors.full_messages.join(" ")
		end
	end

	def restore_all
		if Slide.only_deleted.restore_all
			redirect_to root_path, notice: 'All slides from Trash was successfuly restored.'
		else
			flash_message :error, @slide.errors.full_messages.join(" ")
		end		
	end

	def show
	end

	def set_slide
		@trashed_slide = Slide.only_deleted.find(params[:id])
	end
end
