FactoryGirl.define do
  factory :tournament do
    name { Faker::Company.name }
    handle { Faker::Internet.slug }
    time_cap 90
    welcome_email_sent true
    game_confirm_setting 'automatic'
  end
end
