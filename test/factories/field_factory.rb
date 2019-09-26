FactoryBot.define do
  factory :field do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.state }
    lat { 45.245668169 }
    long { -75.6163644791 }
    geo_json {
      '{
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [-75.61704058530103, 45.24560112337739],
              [-75.61682149825708, 45.24531101502135],
              [-75.61568837209097, 45.24573520582302],
              [-75.61590746188978, 45.2460253137602],
              [-75.61704058530103, 45.24560112337739]
            ]
          ]
        }
      }'
    }
  end
end
