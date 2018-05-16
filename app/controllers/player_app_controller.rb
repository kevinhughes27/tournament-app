class PlayerAppController < ApplicationController
  include TournamentController
  include ReactAppController

  app_name 'player-app'
end
