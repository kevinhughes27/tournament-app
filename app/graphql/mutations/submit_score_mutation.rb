SubmitScoreMutation = GraphQL::Relay::Mutation.define do
  name "SubmitScore"

  input_field :game_id, types.ID
  input_field :team_id, types.ID
  input_field :submitter_fingerprint, types.String
  input_field :home_score, types.Int
  input_field :away_score, types.Int
  input_field :rules_knowledge, types.Int
  input_field :fouls, types.Int
  input_field :fairness, types.Int
  input_field :attitude, types.Int
  input_field :communication, types.Int
  input_field :comments, types.String

  return_field :success, !types.Boolean

  resolve -> (obj, inputs, ctx) {
    op = SubmitScoreReport.new(
      tournament: ctx[:tournament],
      game_id: inputs[:game_id],
      team_id: inputs[:team_id],
      submitter_fingerprint: inputs[:submitter_fingerprint],
      home_score: inputs[:home_score],
      away_score: inputs[:away_score],
      rules_knowledge: inputs[:rules_knowledge],
      fouls: inputs[:fouls],
      fairness: inputs[:fairness],
      attitude: inputs[:attitude],
      communication: inputs[:communication],
      comments: inputs[:comments]
    )

    op.perform

    if op.succeeded?
      { success: true }
    else
      { success: false }
    end
  }
end
