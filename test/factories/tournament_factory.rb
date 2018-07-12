FactoryBot.define do
  factory :tournament do
    name { Faker::Company.name }
    handle { Faker::Internet.domain_word }
    timezone { Time.zone }
    welcome_email_sent true
    game_confirm_setting 'single'
  end
end
