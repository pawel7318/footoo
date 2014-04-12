FactoryGirl.define do

  factory :slide do
    
    association :album
    description { Faker::Name.name }
    sequence(:photo) { |n| Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_#{n%2+1}.jpg", "image/jpeg") }
    
    factory :slide_array do
     photo [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_1.jpg", "image/jpeg")]
    end

    factory :slide_array_multiple do
      photo [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_1.jpg", "image/jpeg"), Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/sample_2.jpg", "image/jpeg")]
    end

    factory :slide_without_photo do
      photo_file_name nil
      photo_content_type nil
      photo_file_size 0
      photo_updated_at nil
      photo_fingerprint nil
    end
  end
end
