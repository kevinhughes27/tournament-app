FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    sign_in_count 5
  end
end
