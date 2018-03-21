Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  constraints(Subdomain) do
    post 'graphql' => 'graphql#create'
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
    draw :admin
    draw :player_app
  end

  draw :brochure

  mount ActionCable.server => '/cable'
end
