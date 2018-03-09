class AdminController < ApplicationController
  include TournamentConcern
  include TournamentCableConcern

  include AdminErrorHandling
  include AdminAuthConcern

  abstract!

  layout 'admin'

  helper UiHelper

  respond_to :html
end
