Rails.application.routes.draw do
  #root 'landing#index'
  #root :to => redirect('/no-borders')
  root :to => redirect('/ocua-2015')

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  get '/new' => 'signup#new'
  post '/new' => 'signup#create'

  resources :tournaments, controller: 'admin/tournaments', path: '', except: [:show] do
    namespace :admin do
      get "/" => "tournaments#show"

      resources :fields

      resources :teams do
        collection do
          get :sample_csv
          post :import_csv
        end
      end

      resources :brackets do
        member do
          put :seed
        end
        collection do
          put :update_seeds
        end
      end

      get '/schedule', to: 'schedule#index'
      post '/schedule', to: 'schedule#update'

      resources :games
    end
  end
  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
