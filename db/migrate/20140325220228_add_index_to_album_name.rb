class AddIndexToAlbumName < ActiveRecord::Migration
  def change
  	add_index :albums, :name, unique: true
  end
end
