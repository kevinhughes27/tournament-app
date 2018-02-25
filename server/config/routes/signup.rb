devise_scope :user do
  post '/sign_up' => 'signup#create', as: :new_user_signup
end

get '/setup' => 'tournaments#new'
post '/setup' => 'tournaments#create'
