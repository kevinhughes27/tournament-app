Rails.application.routes.draw do
  root 'brochure#index'

  devise_for :users,
    path: '',
    controllers: { sessions: 'login', omniauth_callbacks: 'omniauth_callbacks', passwords: 'passwords' },
    skip: [:registration]

  devise_scope :user do
    post '/sign_up' => 'signup#create', as: :new_user_signup
    get '/choose_tournament' => 'login#choose_tournament'
    post '/choose_tournament' => 'login#choose_tournament'
  end

  get '/setup' => 'tournaments#new'
  post '/setup' => 'tournaments#create'

  resources :tournaments, path: 'setup', only: [] do
    resources :build, path: '', controller: 'tournaments_build', only: [:show, :update]
  end

  resources :tournaments, controller: 'tournaments', path: '', only: [] do
    draw :admin
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
