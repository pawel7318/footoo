class AddIndexToSlidePhoto < ActiveRecord::Migration
  def change
  	add_index :slides, :photo_fingerprint, unique: true
  end
end
