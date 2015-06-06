Rails.application.routes.draw do
  resources :tournaments do
    resources :spirits
    resources :fields
    resources :games
    resources :teams
  end

  root 'tournaments#index'
  get 'download_csv_template', to: 'application#download_csv_template'
end
