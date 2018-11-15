Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  constraints(Subdomain) do
    draw :api
    draw :admin
    draw :admin_next
    draw :player_app
  end

  draw :brochure
end
