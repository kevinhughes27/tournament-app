FactoryGirl.define do
  factory :game do
    association :tournament
    association :division
    home_prereq '3'
    away_prereq '6'
    association :home, factory: :team
    association :away, factory: :team
    home_score 2
    away_score 1
    score_confirmed true
  end
end
