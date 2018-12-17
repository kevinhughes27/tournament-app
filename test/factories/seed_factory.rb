FactoryBot.define do
  factory :seed do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    sequence(:seed)
    team { FactoryBot.build(:team, tournament: tournament, name: "Team #{seed}") }
  end
end
