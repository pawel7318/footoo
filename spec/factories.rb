FactoryGirl.define do
	factory :album do
		name Faker::Commerce.product_name
	end

	factory :slide do
		file = File.new(Rails.root.join('spec/fixtures/sample_1.jpg'))
		file.rewind

		description "Sample 1"
		photo ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file), :type => 'image/jpeg')
	end
end
