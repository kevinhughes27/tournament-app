FactoryBot.define do
  factory :team do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.name }
    email { name ? "#{name.parameterize}@example.com" : Faker::Internet.unique.email }
  end
end
