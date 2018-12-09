class ActiveSupport::TestCase
  teardown do
    Faker::UniqueGenerator.clear
  end
end
