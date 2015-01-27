FactoryGirl.define do
	factory :album do
    # replaced by apartment gem:
    # association :user
		name { Faker::Commerce.product_name }

		factory :invalid_album do
			name nil
		end
	end
end
