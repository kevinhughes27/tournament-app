SubmitScoreMutation = GraphQL::Relay::Mutation.define do
  name "SubmitScore"

  input_field :game_id, types.ID
  input_field :team_id, types.ID
  input_field :submitter_fingerprint, types.String
  input_field :team_score, types.Int
  input_field :opponent_score, types.Int
  input_field :rules_knowledge, types.Int
  input_field :fouls, types.Int
  input_field :fairness, types.Int
  input_field :attitude, types.Int
  input_field :communication, types.Int
  input_field :comments, types.String

  return_field :success, !types.Boolean

  resolve ->(object, inputs, ctx) {
    params = inputs.to_h.merge(tournament_id: ctx[:tournament].id)
    confirm_setting = ctx[:tournament].game_confirm_setting
    ScoreReportCreate.perform(params, confirm_setting)
    response = { success: true }
    response
  }
end
