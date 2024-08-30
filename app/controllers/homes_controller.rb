# frozen_string_literal: true

class HomesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @user = current_user
  end
end
