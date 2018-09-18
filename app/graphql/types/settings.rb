class Types::Settings < Types::BaseObject
  graphql_name "Settings"
  description "Tourgraphql_nament Settings"
  field :name, String, null: true
  field :handle, String, null: false
  field :timezone, String, null: true
  field :protectScoreSubmit, Boolean, null: true
  field :gameConfirmSetting, Boolean, null: false

  def protect_score_submit
    context[:tournament].score_submit_pin.present?
  end

  def game_confirm_setting
    context[:tournament].game_confirm_setting.present?
  end

end
