Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  constraints(Subdomain) do
    draw :admin
    draw :api
    draw :player_app
  end

  draw :brochure

  mount ActionCable.server => '/cable'
end
