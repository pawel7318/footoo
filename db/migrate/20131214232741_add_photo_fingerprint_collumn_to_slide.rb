class AddPhotoFingerprintCollumnToSlide < ActiveRecord::Migration
	def self.up
		add_column :slides, :photo_fingerprint, :string
	end

	def self.down
		remove_column :slides, :photo_fingerprint
	end
end
