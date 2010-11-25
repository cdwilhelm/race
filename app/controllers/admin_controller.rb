class AdminController < ApplicationController
  before_filter :authorize,:admin
  ssl_required :index
  layout 'admin'
  def index
  end

end
