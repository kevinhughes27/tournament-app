Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  constraints(Subdomain) do
    post 'graphql' => 'graphqls#create'
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
    draw :admin
    root 'app#index'
    get '/static/*dir/*file', to: 'app#static'
    get '/*path', to: 'app#index'
  end

  draw :brochure

  mount ActionCable.server => '/cable'
end
