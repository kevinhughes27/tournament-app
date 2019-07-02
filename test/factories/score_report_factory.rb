FactoryBot.define do
  factory :score_report do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    game { FactoryBot.build(:game, tournament: tournament) }
    team { FactoryBot.build(:team, tournament: tournament) }
    submitter_fingerprint { Faker::Crypto.sha1 }
    home_score { 15 }
    away_score { 13 }
    rules_knowledge { 3 }
    fouls { 3 }
    fairness { 3 }
    attitude { 3 }
    communication { 3 }
    is_confirmation { false }
  end
end
