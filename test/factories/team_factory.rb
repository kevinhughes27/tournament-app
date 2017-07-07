FactoryGirl.define do
  factory :team do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    name { Faker::Team.name }
    email { Faker::Internet.email }
    sequence(:seed)
  end
end
