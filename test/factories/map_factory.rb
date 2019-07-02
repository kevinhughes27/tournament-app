FactoryBot.define do
  factory :map do
    tournament { Tournament.first || FactoryBot.build(tournament) }
    lat { 45.2466442 }
    long { -75.6149635 }
    zoom { 17 }
  end
end
