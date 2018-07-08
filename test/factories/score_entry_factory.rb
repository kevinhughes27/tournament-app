FactoryBot.define do
  factory :score_entry do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    user { User.first || FactoryBot.build(:user) }
    game { FactoryBot.build(:game, tournament: tournament) }
    home { game.home }
    away { game.away }
    home_score 15
    away_score 13
  end
end
