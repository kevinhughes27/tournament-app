FactoryGirl.define do
  factory :division do
    association :tournament
    name 'Open'
    bracket_type 'single_elimination_8'
  end
end
