class AdminController < ApplicationController
  include TournamentConcern
  include TournamentCableConcern

  include AdminAuthConcern
  include AdminErrorHandling

  layout 'admin'
  helper UiHelper
  respond_to :html
end
