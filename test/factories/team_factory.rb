FactoryGirl.define do
  factory :team do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    name { Faker::Team.name }
    sequence(:seed)
  end
end
