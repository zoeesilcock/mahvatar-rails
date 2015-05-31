class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate

  private

  def authenticate
    if ENV['PASSWORD'] && controller_name != 'home'
      unless authenticate_with_http_basic { |u, p| p == ENV['PASSWORD'] }
        request_http_basic_authentication
      end
    end
  end
end
