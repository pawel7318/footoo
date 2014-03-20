class AddPhotoProcessingToSlide < ActiveRecord::Migration
  def change
  	add_column :slides, :photo_processing, :boolean
  end
end
