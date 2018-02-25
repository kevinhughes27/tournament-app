class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "games_#{current_tournament.id}"
  end
end
