class AdminController < ApplicationController
  before_filter :authorize,:admin
  ssl_required :index

  def index
  end

end
