json.array!(games) do |game|
  json.partial! 'admin/games/game', game: game
end
