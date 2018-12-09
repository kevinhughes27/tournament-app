FactoryBot.define do
  factory :division do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.state }
    num_days 1
    num_teams 8
    bracket_type 'single_elimination_8'
  end
end
