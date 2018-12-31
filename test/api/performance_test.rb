require 'test_helper'

class AdminQueries
  class << self
    def all
      query_dir = Rails.root.join('clients/admin/src/queries/*.ts')

      Dir.glob(query_dir).map do |query_file|
        name = query_file.split('/').last
        query = parse_query(query_file)

        [name, query]
      end
    end

    private

    def parse_query(query_file)
      ts_code = File.read(query_file)

      query_start = ts_code.index("gql`\n") + 6
      query_end = ts_code.index('`;', query_start)
      query_length = query_end - query_start

      query = ts_code.slice(query_start, query_length)

      query
    end
  end
end

class PerformanceTest < ApiTest
  setup do
    login_user

    @division = create_division
    create_team_and_seeds
    seed_division

    create_map
    create_fields
    schedule_games

    create_score_reports
  end

  AdminQueries.all.each do |name, query|
    test "test query #{name}" do
      variables = variables_for_query(query)
      query_graphql(query, variables: variables)
    end
  end

  private

  def create_division
    params = FactoryBot.attributes_for(:division, bracket_type: 'USAU 8.1')
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    assert_success
    Division.last
  end

  def create_team_and_seeds
    n = @division.bracket.teams

    (1..n).map do |rank|
      FactoryBot.create(:seed, division: @division, rank: rank)
    end
  end

  def seed_division
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: @division.id})
    assert @division.reload.seeded?, 'Seeding failed'
  end

  def create_map
    FactoryBot.create(:map)
  end

  def create_fields
    4.times do
      FactoryBot.create(:field)
    end
  end

  def schedule_games
    games = Game.all.limit(12)
    fields = Field.all

    times = [
      ["2018-06-06 8:30:00 UTC",  "2018-06-06 9:30:00 UTC"],
      ["2018-06-06 9:30:00 UTC",  "2018-06-06 10:30:00 UTC"],
      ["2018-06-06 10:30:00 UTC", "2018-06-06 11:30:00 UTC"]
    ]

    game_idx = 0

    times.each do |time|
      fields.each do |field|
        games[game_idx].schedule(field.id, time[0], time[1])
        games[game_idx].save!
        game_idx += 1
      end
    end
  end

  def create_score_reports
    games = Game.with_teams.all.limit(8)
    games.each do |game|
      FactoryBot.create(:score_report, game: game, team: game.home)
    end
  end

  def variables_for_query(query)
    variable_names = query.scan(/\$[a-zA-Z]+/)
    variables = {}

    variable_names.each do |name|
      case name
      when '$teamId'
        variables['teamId'] = Team.first.id
      when '$divisionId'
        variables['divisionId'] = @division.id
      when '$numTeams'
        variables['numTeams'] = 10
      when '$numDays'
        variables['numDays'] = 2
      else
        raise "unset query variable `#{name}`. Edit variables_for_query method in performance_test.rb"
      end
    end

    variables
  end
end
