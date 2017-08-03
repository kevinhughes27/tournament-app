require 'test_helper'

class SchedulableTest < ActiveSupport::TestCase
  test "game must have field if it has a start_time" do
    game = FactoryGirl.build(:game, start_time: Time.now)
    refute game.valid?
    assert_equal ["can't be blank"], game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    field = FactoryGirl.build(:field)
    game = FactoryGirl.build(:game, field: field)
    refute game.valid?
    assert_equal ["can't be blank"], game.errors[:start_time]
  end

  test "can unassign a game from field and start_time" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.create(:game, field: field, start_time: Time.now)
    game.update(field: nil, start_time: nil)
    assert game.errors.empty?
  end

  test "game must have a valid field" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.create(:game, field: field, start_time: Time.now)
    game.update(field_id: 999, start_time: nil)
    assert_equal ["is invalid"], game.errors[:field]
  end
end
