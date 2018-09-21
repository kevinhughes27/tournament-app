class Types::Settings < Types::BaseObject
  graphql_name "Settings"
  description "Tourgraphql_nament Settings"
  field :name, String, null: true
  field :handle, String, null: false
  field :timezone, String, null: true
  field :scoreSubmitPin, String, null: true
  field :gameConfirmSetting, String, null: false

  def score_submit_pin
    context[:tournament].score_submit_pin
  end

  def game_confirm_setting
    context[:tournament].game_confirm_setting
  end

end
