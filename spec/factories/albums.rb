FactoryGirl.define do
	factory :album do
    association :user
		name { Faker::Commerce.product_name }

		factory :invalid_album do
			name nil
		end
	end
end
