class AddAttachmentPhotoToSlides < ActiveRecord::Migration
  def self.up
    change_table :slides do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :slides, :photo
  end
end
