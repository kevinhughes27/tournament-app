devise_scope :user do
  post '/sign_up' => 'signup#create', as: :new_user_signup
end

get '/setup' => 'tournaments#new'
post '/setup' => 'tournaments#create'

resources :tournaments, path: 'setup', only: [] do
  resources :build, path: '', controller: 'tournaments_build', only: [:show, :update]
end
