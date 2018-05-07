post 'graphql' => 'graphql#execute'
mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
