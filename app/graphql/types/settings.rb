class Types::Settings < Types::BaseObject
  graphql_name "Settings"
  description "Tourgraphql_nament Settings"
  field :protectScoreSubmit, Boolean, null: false

  def protect_score_submit
    context[:tournament].score_submit_pin.present?
  end
end
