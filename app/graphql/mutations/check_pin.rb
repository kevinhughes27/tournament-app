class Mutations::CheckPin < Mutations::BaseMutation
  graphql_name "CheckPin"

  argument :input, Inputs::CheckPinInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true

  def resolve(input)
    valid = (input[:input][:pin] == context[:tournament].score_submit_pin)

    if valid
      { success: true }
    else
      { success: false, user_errors: ['Incorrect pin'] }
    end
  end
end
