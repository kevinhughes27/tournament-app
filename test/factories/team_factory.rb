FactoryBot.define do
  factory :team do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    name { Faker::Team.unique.name }
    email { Faker::Internet.unique.email }
    sequence(:seed)
  end
end
