class ChangeBracket < ApplicationOperation
  property :tournament_id, accepts: Integer, required: true
  property :division_id, accepts: Integer, required: true
  property :new_template, accepts: Hash, required: true

  attr_reader :template_games

  def execute
    @template_games = new_template[:games]

    games_to_keep = games.select do |game|
      matches_template_game?(game)
    end

    games_to_delete = games - games_to_keep

    games_to_create = template_games.select do |template_game|
      !matches_game?(template_game)
    end

    games_to_delete.map(&:destroy!)

    games_to_create.each do |template_game|
      Game::create_from_template!(
        tournament_id: tournament_id,
        division_id: division_id,
        template_game: template_game
      )
    end

    recreate_places
  end

  private

  def games
    @games ||= Game.where(
      tournament_id: tournament_id,
      division_id: division_id
    )
  end

  def matches_template_game?(game)
    template_games.detect do |template_game|
      template_game[:pool] == game.pool &&
      template_game[:round].to_s == game.round.to_s &&
      template_game[:bracket_uid].to_s == game.bracket_uid.to_s &&
      template_game[:home_prereq].to_s == game.home_prereq.to_s &&
      template_game[:away_prereq].to_s == game.away_prereq.to_s
    end.present?
  end

  def matches_game?(template_game)
    games.detect do |game|
      template_game[:pool] == game.pool &&
      template_game[:round].to_s == game.round.to_s &&
      template_game[:bracket_uid].to_s == game.bracket_uid.to_s &&
      template_game[:home_prereq].to_s == game.home_prereq.to_s &&
      template_game[:away_prereq].to_s == game.away_prereq.to_s
    end.present?
  end

  def recreate_places
    Place.where(
      tournament_id: tournament_id,
      division_id: division_id
    ).destroy_all

    CreatePlacesJob.perform_now(
      tournament_id: tournament_id,
      division_id: division_id,
      template: new_template
    )
  end
end
