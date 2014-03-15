FactoryGirl.define do
	factory :album do
		name Faker::Commerce.product_name
	end

	factory :slide do
		association :album
		# should be associated with Album so use
		# FactoryGirl.create(:slide, :album => @album) where @album is set to some existing album
		file = File.new(Rails.root.join('spec/fixtures/sample_1.jpg'))
		file.rewind

		description Faker::Name.name
		photo ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file), :type => 'image/jpeg')
	end
end
