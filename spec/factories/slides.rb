#include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :slide do

    association :album
    description Faker::Name.name    
    photo Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_1.jpg", "image/jpeg")
    # A few other ways to do the upload:
    #file = File.new(Rails.root.join('spec/fixtures/sample_1.jpg'))
    #file.rewind
    #photo ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file), :type => 'image/jpeg')
    # or
    #photo { fixture_file_upload(Rails.root.join('spec/fixtures/sample_1.jpg'), 'image/jpeg') }

    factory :slide_array do
     photo [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_1.jpg", "image/jpeg")]
   end
 end
end
