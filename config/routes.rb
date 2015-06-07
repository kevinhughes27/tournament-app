Rails.application.routes.draw do
  resources :tournaments do
    resources :spirits
    resources :fields
    resources :games
    resources :teams
    post :import_team
  end

  root 'statics#index'
  get 'download_csv_template', to: 'application#download_csv_template'
end
