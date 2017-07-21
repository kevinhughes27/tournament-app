FactoryGirl.define do
  factory :tournament_user do
    association :tournament
    association :user
  end
end
