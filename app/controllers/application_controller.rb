class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :init_session
  
  def init_session
    session[:basket_count] ||= 0
  end
end
