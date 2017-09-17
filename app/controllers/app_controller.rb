class AppController < ApplicationController
  include TournamentConcern

  layout false
  protect_from_forgery except: [:static]

  def index
    render file: index_html
  end

  def static
    render file: static_file(params[:dir], params[:file])
  end

  private

  def index_html
    Rails.root.join('player-app', 'build', 'index.html')
  end

  def static_file(dir, file)
    Rails.root.join('player-app', 'build', 'static', dir, file)
  end
end
