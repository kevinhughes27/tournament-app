Rails.application.routes.draw do
  root 'home#index'
  #root :to => redirect('/no-borders')

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  namespace :admin do
    resources :tournaments, path: '' do

      resources :maps

      resources :fields

      resources :teams do
        collection do
          post :import
        end
      end

      resources :seeding do
        collection do
          put :update
        end
      end

      resources :brackets do
        member do
          put :seed
        end
      end

      get '/schedule', to: 'schedule#index'
      post '/schedule', to: 'schedule#create'

      resources :games do
        member do
          put :confirm_score
          put :update_score
        end
      end

      resources :score_reports
    end
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
