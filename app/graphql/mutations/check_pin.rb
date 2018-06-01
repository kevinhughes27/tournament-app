class Mutations::CheckPin < Mutations::BaseMutation
  graphql_name "CheckPin"
  public_mutation

  argument :input, Inputs::CheckPinInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
end
