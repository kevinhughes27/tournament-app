post 'user_token' => 'user_token#create'
post 'graphql' => 'graphql#execute'
mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
mount ActionCable.server => '/subscriptions'
