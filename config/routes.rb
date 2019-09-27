Rails.application.routes.draw do
  draw :signup
  draw :login

  draw :internal

  get "*manifest.json", to: redirect('/manifest.json')

  constraints(Subdomain) do
    draw :api
    draw :files
    draw :admin
    draw :player_app
  end

  draw :brochure
end
