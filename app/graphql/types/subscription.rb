class Types::Subscription < Types::BaseObject
  field :gameUpdated, Types::Game, null: false,
    subscription_scope: :current_tournament,
    description: "Game updated"

  def game_updated
  end
end
