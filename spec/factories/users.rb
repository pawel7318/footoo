FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name }
    email { Faker::Internet.email("#{username}") }
    password "login_as will not use it anyway"
  end
end
