FactoryBot.define do
  factory :field do
    tournament { Tournament.first || FactoryBot.build(:tournament) }
    name { Faker::Team.unique.state }
    lat { 45.2442971314328 }
    long { -75.6138271093369 }
    geo_json {
      '{
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [-75.61601042747499, 45.24671814226571],
              [-75.61532378196718, 45.2459627677447],
              [-75.61486244201662, 45.246189381155695],
              [-75.61551690101625, 45.24692209166425],
              [-75.61601042747499, 45.24671814226571]
            ]
          ]
        }
      }'
    }
  end
end
