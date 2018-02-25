require 'sidekiq/web'

namespace :internal do
  get "/" => "dashboard#show"

  devise_for :users,
    path: '',
    path_names: { sign_in: 'log_in' },
    controllers: { sessions: 'internal/login' },
    skip: [:registration, :omniauth_callbacks, :passwords]

  resources :tournaments, only: [:index]

  authenticate :user, lambda { |u| u.staff? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
