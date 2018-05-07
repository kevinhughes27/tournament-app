class PlayerAppController < ApplicationController
  include TournamentConcern
  include ReactAppController

  app_name 'player-app'
end
