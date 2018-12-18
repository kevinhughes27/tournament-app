FactoryBot.define do
  factory :team do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.name }
    email { Faker::Internet.unique.email }
  end
end
