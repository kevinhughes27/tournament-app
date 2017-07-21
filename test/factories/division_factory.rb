FactoryGirl.define do
  factory :division do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    name { Faker::Team.state }
    num_days 1
    num_teams 8
    bracket_type 'single_elimination_8'
  end
end