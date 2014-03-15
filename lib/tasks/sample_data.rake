require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do

		@samples = Dir[Rails.root.join "spec/fixtures/*.jpg"]
 

		4.times do |n|
			name = Faker::Commerce.product_name
			@album = Album.create!(name: name)
			
			if @samples[n] then
				@photo = File.open @samples[n]
				@album.slides.create!(album_id: @album, description: Faker::Name.name, photo: @photo)
			end
		end

		# @photo = Rails.root.join('spec/fixtures/DSC_2254.JPG').open
		# @album.slides.create!(album_id: @album, description: "Blaa", photo: @photo)

	end
end

