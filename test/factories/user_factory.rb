FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password Devise::Encryptor.digest(User, 'password')
    sign_in_count 5
  end
end
