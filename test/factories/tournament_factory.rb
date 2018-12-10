FactoryBot.define do
  factory :tournament do
    name { Faker::Company.unique.name }
    handle { Faker::Internet.unique.domain_word }
    timezone 'Etc/UTC'
    welcome_email_sent true
    game_confirm_setting 'single'
  end
end
