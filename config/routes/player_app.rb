root 'app#index'
get '/static/*dir/*file', to: 'app#static'
get '/service_worker', to: 'app#service_worker'

get '/*path', to: 'app#index'
