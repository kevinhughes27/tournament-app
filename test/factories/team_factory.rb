FactoryGirl.define do
  factory :team do
    association :tournament
    name { Faker::Team.name }
  end
end
