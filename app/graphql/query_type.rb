QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The root query for this schema"

  field :settings do
    type SettingsType
    resolve -> (obj, args, ctx) {
      ctx[:tournament]
    }
  end

  field :map do
    type MapType
    resolve -> (obj, args, ctx) {
      ctx[:tournament].map
    }
  end

  field :fields do
    type types[FieldType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].fields.all
    }
  end

  field :field, FieldType do
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      ctx[:tournament].fields.find(args[:id])
    }
  end

  field :teams do
    type types[TeamType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].teams.all
    }
  end

  field :team, TeamType do
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      ctx[:tournament].teams.find(args[:id])
    }
  end

  field :divisions do
    type types[DivisionType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].divisions.all
    }
  end

  field :divisions, DivisionType do
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      ctx[:tournament].divisions.find(args[:id])
    }
  end

  field :games do
    type types[GameType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].games
        .scheduled
        .with_team
        .includes(:home, :away, :field)
        .all
    }
  end

  field :game, GameType do
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      ctx[:tournament].game.find(args[:id])
    }
  end

  field :score_reports do
    type types[ScoreReportType]
    resolve -> (obj, args, ctx) {
      ctx[:tournament].score_reports.all
    }
  end

  field :score_report, ScoreReportType do
    argument :id, types.ID
    resolve -> (obj, args, ctx) {
      ctx[:tournament].score_report.find(args[:id])
    }
  end
end
