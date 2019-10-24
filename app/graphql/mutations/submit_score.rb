class Mutations::SubmitScore < Mutations::BaseMutation
  graphql_name "SubmitScore"
  public_mutation

  argument :input, Inputs::SubmitScoreInput, required: true

  field :success, Boolean, null: false
  field :gameId, ID, null: false
  field :submitterFingerprint, String, null: false
end
