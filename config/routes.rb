Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: { sign_in: 'log_in' },
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

  namespace :internal do
    get "/" => "dashboard#show"
  end

  constraints(Subdomain) do
    draw :admin
    get '/' => 'app#show', as: 'app'
    post '/submit_score' => 'app#score_submit', as: 'app_score_submit'
    get '/confirm/:id' => 'app#confirm'
    post '/confirm/:id' => 'app#confirm'
  end

  root 'brochure#index'
end
