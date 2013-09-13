# SOURCE: app/controllers/application_controller.rb
# Everything included here is recognized whatever the path

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This is here so user signin status is remembered “forever” and ends the
  ## session only when the user explicitly signs out
  # helpers are usually not available in controllers
  include SessionsHelper  # AKA  app/helpers/sessions_helper.rb

end
