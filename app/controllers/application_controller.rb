# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :authenticate_user_with_spotify!

  def authenticate_user_with_spotify!(&)
    authenticate_user!
    return if performed?

    current_user.authenticated(&)
  end
end
