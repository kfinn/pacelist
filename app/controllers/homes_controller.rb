# frozen_string_literal: true

class HomesController < ApplicationController
  skip_around_action :authenticate_user_with_spotify!

  def show
    @user = current_user
    return if @user.blank?

    current_user.authenticated do
      @spotify_saved_tracks = Spotify::SavedTrack.where(offset: 0, limit: 10)
    end
  end
end
