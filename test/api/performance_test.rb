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

  ALLOWED_QUERIES = {
    'DivisionListQuery.ts' => 4,
    'TeamShowQuery.ts' => 4,
    'FieldsEditorQuery.ts' => 4,
    'GamesListQuery.ts' => 10,
    'ScheduleEditorQuery.ts' => 11, # loads score_reports and score_disputes for no reason
    'DivisionSeedQuery.ts'=> 15, # N+1 loads seeds through teams
    'TeamListQuery.ts' => 15, # N+1 reloads the division through the team
    'HomeQuery.ts' => 17, # some duplicate fetching but not terrible considering
    'DivisionShowQuery.ts' => 28, # N+1 team
    'DivisionEditQuery.ts' => 28, # N+1 team
  }

  # global issues
  # teams are queried twice a lot since I preload home and away

  AdminQueries.all.each do |name, query|
    test "query #{name}" do
      variables = variables_for_query(query)
      query_count = ALLOWED_QUERIES.fetch(name, 2)

      assert_queries(query_count) do
        query_graphql(query, variables: variables)
        assert_query_result(name, query_result)
      end
    end
  end

  private

  def create_division
    params = FactoryBot.attributes_for(:division, name: 'Open', bracket_type: 'USAU 8.1')
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
    4.times do |i|
      FactoryBot.create(:field, name: "Field #{i}")
    end
  end

  def schedule_games
    games = Game.all.order(:id).limit(12)
    fields = Field.all.order(:id)

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
    games.each_with_index do |game, idx|
      FactoryBot.create(:score_report, game: game, team: game.home, submitter_fingerprint: "#{idx}")
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

  def assert_queries(num, &block)
    count = 0
    queries = []

    counter_f = -> (name, started, finished, unique_id, payload) {
      count += 1
      query = "#{payload[:name]} #{payload[:sql]} #{payload[:type_casted_binds]}"
      queries.push(query)
    }

    ActiveSupport::Notifications.subscribed(counter_f, "sql.active_record", &block)
  ensure
    mesg = "#{count} instead of #{num} queries were executed.#{count == 0 ? '' : "\nQueries:\n#{queries.join("\n")}"}"
    assert_equal num, count, mesg
  end

  def assert_query_result(name, result)
    expected_result_path = Rails.root.join('test/files/performance', name.gsub('.ts', '.json'))
    if File.exist?(expected_result_path)
      expected_result = JSON.parse(File.read(expected_result_path))

      delete_key(expected_result, 'id')
      delete_key(result, 'id')

      # File.write('expected.json', JSON.pretty_generate(expected_result))
      # File.write('result.json', JSON.pretty_generate(result))

      assert_equal expected_result, result, 'Query result changed'
    else
      File.write(expected_result_path, result.to_json)
    end
  end

  # delete all nested keys in a hash
  def delete_key(hash, key)
    hash.each do |k, v|
      if k == key
        hash.delete(k)
      elsif v.instance_of?(Hash)
        delete_key(v, key)
      elsif v.instance_of?(Array)
        v.each { |v| delete_key(v, key) }
      end
    end
  end
end
