FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }
    sign_in_count { 5 }

    factory :staff do
      email { 'kevinhughes27@gmail.com' }
    end
  end
end
