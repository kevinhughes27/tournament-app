class BrochureController < ApplicationController
  layout 'brochure'

  def index
    render :index
  end

  def tos
    render :tos, layout: false
  end
end
