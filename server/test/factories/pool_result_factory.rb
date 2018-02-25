FactoryGirl.define do
  factory :pool_result do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    division { Division.first || FactoryGirl.build(:division, tournament: tournament) }
    pool 'A'
    team { FactoryGirl.build(:team, tournament: tournament) }
    wins 2
    points 15
  end
end
