class Slide < ActiveRecord::Base
	paranoid
	belongs_to :album

	has_attached_file :photo, :preserve_files => true,  :styles => { :medium => "800x800>", :small => "300x300>", :thumb => "150x150>" }, :convert_options => { :medium => "-quality 70 -interlace Plane -strip", :small => "-quality 70 -interlace Plane -strip", :thumb => "-quality 70 -interlace Plane -strip" }, :default_url => "/images/coming_soon.png"
	validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg)
	validates :photo, presence: true
	validates :photo_fingerprint, uniqueness: true

	process_in_background :photo

	# validates :album_id, presence: true
end
