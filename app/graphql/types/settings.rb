class Types::Settings < Types::BaseObject
  graphql_name "Settings"
  description "Tournament Settings"
  field :name, String, null: true
  field :handle, String, null: false
  field :timezone, String, null: false
  field :protectScoreSubmit, Boolean, null: false
  field :scoreSubmitPin, String, null: true
  field :gameConfirmSetting, String, null: false

  def timezone
    context[:tournament].timezone
  end

  def protect_score_submit
    context[:tournament].score_submit_pin.present?
  end

  def score_submit_pin
    context[:tournament].score_submit_pin
  end

  def game_confirm_setting
    context[:tournament].game_confirm_setting
  end
end
