# frozen_string_literal: true

module Spotify
  class PlaylistItem
    def self.where(spotify_playlist_id:, limit: 50, offset: 0)
      SPOTIFY_CONNECTION
        .get("playlists/#{spotify_playlist_id}/tracks", { offset:, limit: })
        .body
        .fetch('items')
        .map { |attributes| new(attributes.slice('id')) }
    end

    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :string

    def uri
      "spotify:track:#{id}"
    end
  end
end
