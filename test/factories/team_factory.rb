FactoryBot.define do
  factory :team do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.name }
    email { "#{name.parameterize}@example.com" }
  end
end
