Rails.application.routes.draw do
  root 'home#index'

  namespace :admin do
    resources :tournaments, path: '' do
      resources :maps
      resources :fields
      resources :games
      resources :teams do
        collection do
          post :import
        end
      end
      resources :spirits
    end

    get 'download_csv_template', to: 'application#download_csv_template'
    get 'handle_example', to: 'application#handle_example'
  end

  get '*tournament_id' => 'app#show'
end
