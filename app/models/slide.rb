  class Slide < ActiveRecord::Base
  	paranoid
  	belongs_to :album

  	has_attached_file :photo,
    :preserve_files => true,
    :styles => { :medium => "800x800>", :thumb => "200x200>" },
    :convert_options => { :medium => "-quality 80 -interlace Plane -strip", :thumb => "-quality 80 -interlace Plane -strip" },
    :default_url => "/images/coming_soon.png",
    :use_timestamp => false
    validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg)
    validates :photo, presence: true
    validates :photo_fingerprint, uniqueness: true

    process_in_background :photo, queue: 'paperclip'

  	# validates :album_id, presence: true
  end
