Rails.application.routes.draw do
  root 'brochure#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users, path: '', skip: [:registration, :passwords]

  devise_scope :user do
    post '/sign_up' => 'signup#create', as: :new_user_signup
  end

  # i don't like the tournament builder paths off of root
  resources :tournaments, controller: 'tournaments', path: '', only: [:new, :create] do
    draw :admin
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
