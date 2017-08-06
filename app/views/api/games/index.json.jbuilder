json.array!(@games) do |game|
  json.extract! game,
    :id,
    :home_name,
    :away_name,
    :start_time,
    :end_time

  json.field_name game.field&.name
end
