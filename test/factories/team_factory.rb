FactoryGirl.define do
  factory :team do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    division { Division.first || FactoryGirl.build(:division, tournament: tournament) }
    name { Faker::Team.name }
    email { Faker::Internet.email }
    sequence(:seed)
  end
end
