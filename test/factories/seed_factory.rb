FactoryBot.define do
  factory :seed do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    sequence(:rank)
    team { FactoryBot.build(:team, tournament: tournament, name: "Team #{rank}") }
  end
end
