namespace :api do
  resources :teams, only: :index
  resources :fields, only: :index
  resources :games, only: :index
end
