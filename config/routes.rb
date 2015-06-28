Rails.application.routes.draw do
  root 'home#index'

  namespace :admin do
    resources :tournaments do
      resources :maps
      resources :fields
      resources :games
      resources :teams
      resources :spirits
      post :import_team
    end

    get 'download_csv_template', to: 'application#download_csv_template'
    get 'handle_example', to: 'application#handle_example'
  end

  get '*tournament_id' => 'app#show'
end
