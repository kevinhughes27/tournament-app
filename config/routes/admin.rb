namespace :admin do
  get "/" => "home#show"

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

  resources :games

  get '/settings', to: 'settings#show'
  put '/settings', to: 'settings#update'

  get '/map', to: 'map#show'
  put '/map', to: 'map#update'

  get '/account', to: 'account#show'
  put '/account', to: 'account#update'

  unless Rails.application.config.consider_all_requests_local
    get '/*a', to: 'errors#not_found'
  end
end
