class Slide < ActiveRecord::Base
	has_attached_file :photo, :styles => { :medium => "800x800>", :small => "300x300>", :thumb => "150x105>" }, :default_url => "/images/:style/missing.png"
	belongs_to :album
	# validates :album_id, presence: true

end
