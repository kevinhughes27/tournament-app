require "test_helper"

class GamesTest < AdminTest
  test 'game tabs' do
    on_now = FactoryBot.create(:game, :on_now)
    missing_score = FactoryBot.create(:game, :past)
    disputed_score = FactoryBot.create(:game, :past)
    FactoryBot.create(:score_dispute, game: disputed_score)
    upcoming = FactoryBot.create(:game, :upcoming)
    finished = FactoryBot.create(:game, :finished)

    visit_app
    login
    side_menu('Games')

    click_tab('On Now')
    assert_game(on_now)
    refute_games([missing_score, disputed_score, upcoming, finished])

    click_tab('Need Scores')
    assert_game(missing_score)
    assert_game(disputed_score)
    refute_games([on_now, upcoming, finished])

    click_tab('Upcoming')
    assert_game(upcoming)
    refute_games([on_now, missing_score, disputed_score, finished])

    click_tab('Finished')
    assert_game(finished)
    refute_games([on_now, missing_score, disputed_score, upcoming])
  end

  test 'update score' do
    game = FactoryBot.create(:game, :past)

    visit_app
    login
    side_menu('Games')
    click_tab('Need Scores')
    assert_game(game)
    click_game(game)
    fill_in("homeScore", with: 15)
    fill_in("awayScore", with: 12)
    submit

    sleep(1)

    game.reload
    assert game.confirmed?
    assert_equal 15, game.home_score
    assert_equal 12, game.away_score
  end

  test 'update score unsafe' do
    game1 = FactoryBot.create(:game, :scheduled, :past, :finished)
    winner = game1.winner
    game2 = FactoryBot.create(:game, :scheduled, :past, :finished, home: winner, home_prereq: "W#{game1.bracket_uid}")

    visit_app
    login
    side_menu('Games')
    click_tab('Finished')
    assert_game(game1)
    assert_game(game2)
    assert_text(winner.name, count: 2)

    click_game(game1)
    fill_in("homeScore", with: " ")
    fill_in("homeScore", with: game1.away_score)
    fill_in("awayScore", with: " ")
    fill_in("awayScore", with: game1.home_score)
    submit
    assert_text("Confirmation Required")
    click_text("Confirm")

    sleep(1)

    # close the modal
    click_text("Cancel")

    game1.reload
    game2.reload
    new_winner = game1.winner

    assert_not_equal winner, new_winner
    assert_equal new_winner, game2.home

    # this tests graphql subscriptions over websockets with action cable
    assert_text(new_winner.name)
    click_tab('Need Scores')
    assert_text(new_winner.name)
  end

  private

  def click_tab(tab)
    click_text(tab)
  end

  def click_game(game)
    click_text("#{game.home_name} vs #{game.away_name}")
  end

  def assert_game(game)
    assert_text(game.home_name)
    assert_text(game.away_name)
  end

  def refute_games(games)
    games.each do |game|
      assert_no_text(game.home_name)
      assert_no_text(game.away_name)
    end
  end
end
