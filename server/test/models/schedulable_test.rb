require 'test_helper'

class SchedulableTest < ActiveSupport::TestCase
  test "game must have field if it has a start_time" do
    game = FactoryGirl.build(:game, start_time: Time.now)
    refute game.valid?
    assert_equal ["can't be blank"], game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.build(:game, field: field)
    refute game.valid?
    assert_equal ["can't be blank", "is not a date"], game.errors[:start_time]
  end

  test "game must have end_time if it has a field" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.build(:game, field: field)
    refute game.valid?
    assert_equal ["can't be blank", "is not a date"], game.errors[:end_time]
  end

  test "can unassign a game from field and time" do
    game = FactoryGirl.create(:game, :scheduled)
    game.update(field: nil, start_time: nil, end_time: nil)
    assert game.errors.empty?
  end

  test "game must have a valid field" do
    game = FactoryGirl.create(:game, :scheduled)
    game.update(field_id: 999)
    assert_equal ["can't be blank"], game.errors[:field]
  end
end
