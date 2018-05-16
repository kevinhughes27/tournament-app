root 'player_app#index'

get '/static/*dir/*file', to: 'player_app#static'
get '/service-worker', to: 'player_app#service_worker'

get '/*path', to: 'player_app#index'
