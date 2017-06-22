FactoryGirl.define do
  factory :score_report do
    association :tournament
    association :game
    association :team
    team_score 15
    opponent_score 13
    rules_knowledge 3
    fouls 3
    fairness 3
    attitude 3
    communication 3
    is_confirmation false
  end
end
