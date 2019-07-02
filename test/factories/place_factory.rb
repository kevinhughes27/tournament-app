FactoryBot.define do
  factory :place do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    division { Division.first || FactoryBot.build(:division, tournament: tournament) }
    team { FactoryBot.build(:team, tournament: tournament) }
    position { 1 }
    prereq { 'Wf' }
  end
end
