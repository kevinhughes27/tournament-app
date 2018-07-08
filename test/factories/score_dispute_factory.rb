FactoryBot.define do
  factory :score_dispute do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    game { FactoryBot.build(:game, tournament: tournament) }
  end
end
