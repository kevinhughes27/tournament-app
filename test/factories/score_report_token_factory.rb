FactoryGirl.define do
  factory :score_report_confirm_token do
    tournament { Tournament.first || FactoryGirl.build(:tournament) }
    association :score_report
    token { SecureRandom.hex[0,10].upcase }
  end
end
