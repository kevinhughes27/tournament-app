FactoryBot.define do
  factory :team do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    name { Faker::Team.name }
    email { Faker::Internet.email }
    sequence(:seed)
  end
end
