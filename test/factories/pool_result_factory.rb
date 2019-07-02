FactoryBot.define do
  factory :pool_result do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    pool { 'A' }
    team { FactoryBot.build(:team, tournament: tournament) }
    wins { 2 }
    points { 15 }
  end
end
