FactoryGirl.define do
  factory :place do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    division { Division.first || FactoryGirl.build(:division, tournament: tournament) }
    team { FactoryGirl.build(:team, tournament: tournament) }
    position 1
    prereq 'Wf'
  end
end
