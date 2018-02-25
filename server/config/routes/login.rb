devise_for :users,
  path: '',
  path_names: { sign_in: 'log_in' },
  controllers: { sessions: 'login', omniauth_callbacks: 'omniauth_callbacks', passwords: 'passwords' },
  skip: [:registration]

devise_scope :user do
  get '/choose_tournament' => 'login#choose_tournament'
  post '/choose_tournament' => 'login#choose_tournament'
end
