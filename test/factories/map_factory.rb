FactoryGirl.define do
  factory :map do
    association :tournament
    lat 45.2466442
    long -75.6149635
    zoom 17
  end
end
