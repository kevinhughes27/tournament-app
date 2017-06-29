FactoryGirl.define do
  factory :game do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    division { FactoryGirl.build(:division, tournament: tournament) }
    round 1
    bracket_uid { Faker::Number.hexadecimal(3) }
    home_prereq '1'
    away_prereq '3'
    home { FactoryGirl.build(:team, tournament: tournament) }
    away { FactoryGirl.build(:team, tournament: tournament) }

    factory :finished_game do
      home_score { Faker::Number.between(0,15) }
      away_score { Faker::Number.between(0,15) }
      score_confirmed true
    end
  end
end
