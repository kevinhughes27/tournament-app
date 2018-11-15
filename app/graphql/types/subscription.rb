class Types::Subscription < Types::BaseObject
  field :gameUpdated, Types::Game, null: false,
    description: "Game updated",
    subscription_scope: :tournament_id

  def game_updated
  end
end
