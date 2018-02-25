class BackfillSeedRound < ActiveRecord::Migration[5.0]
  def change
    bracket_types = [
      'single_elimination_8',
      'single_elimination_4',
      'round_robin_5',
      'usau_3.1',
      'usau_4.1.1',
      'usau_4.1.2',
    ]

    Division.where(bracket_type: bracket_types).each do |division|
      template = division.bracket.template
      template[:games].each do |template_game|
        next unless template_game[:seed_round]
        game = division.games.find_by(bracket_uid: template_game[:bracket_uid])
        game.update_columns(seed_round: template_game[:seed_round])
      end
    end
  end
end
