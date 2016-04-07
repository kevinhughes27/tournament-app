require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
  end

  test "deleting a field unassigns any games from that field" do
    field = fields(:upi1)
    game = games(:swift_goose)
    assert_equal field, game.field

    field.destroy

    assert_nil game.reload.field
  end

  test "safe_to_delete? is true for field with no games" do
    field = fields(:upi4)
    assert field.safe_to_delete?
  end

  test "safe_to_delete? is false for field games" do
    field = fields(:upi1)
    refute field.safe_to_delete?
  end

  test "limited number of fields per tournament" do
    stub_constant(Field, :LIMIT, 2) do
      field = @tournament.fields.build(name: 'new field')
      refute field.valid?
      assert_equal ['Maximum of 2 fields exceeded'], field.errors[:base]
    end
  end

  test "geo json must be valid json" do
    params = field_attributes
    params[:geo_json] = 'not json }'

    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be valid JSON'], field.errors[:geo_json]
  end

  test "lat must be number" do
    params = field_attributes
    params[:lat] = 'not number'

    field = Field.new(params)

    refute field.valid?
    assert_equal ['is not a number'], field.errors[:lat]
  end

  test "lat must be smaller than 90" do
    params = field_attributes
    params[:lat] = 100

    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be less than or equal to 90'], field.errors[:lat]
  end

  test "lat must be greater than -90" do
    params = field_attributes
    params[:lat] = -100

    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be greater than or equal to -90'], field.errors[:lat]
  end

  test "long must be number" do
    params = field_attributes
    params[:long] = 'not number'

    field = Field.new(params)

    refute field.valid?
    assert_equal ['is not a number'], field.errors[:long]
  end

  test "long must be smaller than 180" do
    params = field_attributes
    params[:long] = 190

    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be less than or equal to 180'], field.errors[:long]
  end

  test "long must be greater than -180" do
    params = field_attributes
    params[:long] = -190

    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be greater than or equal to -180'], field.errors[:long]
  end

  test "limit is defined" do
    assert_equal 64, Field::LIMIT
  end

  private

  def field_attributes
    {
      name: 'UPI7',
      tournament_id: @tournament.id,
      lat: 45.2442971314328,
      long: -75.6138271093369,
      geo_json: geo_json
    }
  end

  def geo_json
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
  end
end
