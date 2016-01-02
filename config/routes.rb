Rails.application.routes.draw do
  root 'brochure#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users, path: '', except: [:passwords]

  resources :tournaments, controller: 'admin/tournaments', path: '', only: [:create] do
    draw :admin
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
