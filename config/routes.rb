Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  constraints(Subdomain) do
    draw :admin
    draw :player_app
  end

  mount ActionCable.server => '/cable'

  get '/tos' => 'brochure#tos'
  root 'brochure#index'
end
