namespace :admin do
  get "/" => "home#show"

  get '/map', to: 'map#show'
  put '/map', to: 'map#update'

  resources :fields do
    collection do
      get :sample_csv
      post :import_csv
      get :export_csv
    end
  end

  resources :divisions do
    member do
      put :update_teams
      put :seed
    end
  end

  resources :teams do
    collection do
      get :sample_csv
      post :import_csv
    end
  end

  get '/schedule', to: 'schedule#index'
  post '/schedule', to: 'schedule#update'

  resources :games, only: [:index, :update]
  resources :score_reports, only: [:index]

  get '/settings', to: 'settings#show'
  put '/settings', to: 'settings#update'
  post '/reset', to: 'settings#reset_data'

  get '/account', to: 'account#show'
  put '/account', to: 'account#update'

  get '/player_app', to: 'player_app#show'

  put '/bulk_action', to: 'bulk_actions#perform'

  unless Rails.application.config.consider_all_requests_local
    get '/*a', to: 'errors#not_found'
  end
end
