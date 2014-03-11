class Slide < ActiveRecord::Base
	has_attached_file :photo, :preserve_files => true,  :styles => { :medium => "800x800>", :small => "300x300>", :thumb => "150x105>" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg)
	validates :photo, presence: true
	belongs_to :album
	# validates :album_id, presence: true
end
