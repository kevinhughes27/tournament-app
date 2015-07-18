Rails.application.routes.draw do
  root 'home#index'

  namespace :admin do
    resources :tournaments, path: '' do
      resources :maps
      resources :fields
      resources :teams do
        collection do
          post :import
        end
      end
      get '/schedule', to: 'schedule#index'
      post '/schedule', to: 'schedule#create'
      resources :games do
        member do
          post :confirm_score
        end
      end
      resources :score_reports
    end

    get 'download_csv_template', to: 'application#download_csv_template'
    get 'handle_example', to: 'application#handle_example'
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
