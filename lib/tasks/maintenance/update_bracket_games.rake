namespace :m do
  task :update_bracket_games => :environment do
    Division.find_each do |division|
      bracket = Bracket.find_by(handle: division.bracket_type)
      template = bracket.template
      division.games.each do |game|
        template_game = template_game_for_game(template, game)
        next unless template_game
        game.update_columns(remap(template_game))
      end
    end
  end
end

def template_game_for_game(template, game)
  if game.pool_game?
    template['games'].detect do |tg|
      tg[:pool] == game.pool &&
      tg[:home].to_s == game.home_prereq_uid &&
      tg[:away].to_s == game.away_prereq_uid
    end
  else
    template['games'].detect{ |tg| tg[:uid] == game.bracket_uid }
  end
end

def remap(template_game)
  template_game.delete('seed')

  keymap = {
    "home" => "home_prereq_uid",
    "away" => "away_prereq_uid",
    "uid" => "bracket_uid"
  }

  template_game.map do |k, v|
    if keymap.key?(k)
      [keymap[k], v]
    else
      [k, v]
    end
  end.to_h
end
