FactoryGirl.define do
  factory :score_report do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    association :game
    association :team
    submitter_fingerprint { Faker::Crypto.sha1 }
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
