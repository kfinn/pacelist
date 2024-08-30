# frozen_string_literal: true

class PlaylistsController < ApplicationController
  def show
    @playlist = current_user.playlists.find params[:id]
  end

  def new
    @playlist = current_user.playlists.build
  end

  def create
    @playlist = current_user.playlists.build(playlist_params)
    if @playlist.save
      redirect_to playlist_path(@playlist)
    else
      render :new
    end
  end

  def playlist_params
    params.require(:playlist).permit(:name, :min_tempo, :max_tempo)
  end
end
