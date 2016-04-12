class BrochureController < ApplicationController
  def index
    render :index, layout: false
  end

  def tos
    render :tos, layout: false
  end
end
