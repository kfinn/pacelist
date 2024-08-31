# frozen_string_literal: true

module Spotify
  class Playlist
    def self.find(id)
      new(
        SPOTIFY_CONNECTION
          .get("playlists/#{id}")
          .body
          .slice('id', 'snapshot_id')
      )
    end

    def self.create!(name:, public:)
      user_id = User.authenticated_user.uid

      new(
        SPOTIFY_CONNECTION
          .post(
            "users/#{user_id}/playlists",
            { name:, public: }
          )
          .body
          .slice('id', 'snapshot_id')
      )
    end

    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :string
    attribute :snapshot_id, :string

    def playlist_items
      @playlist_items ||= PlaylistItem.where(spotify_playlist_id: id)
    end

    def delete_playlist_items!(playlist_items)
      delete_playlist_items_response =
        SPOTIFY_CONNECTION
        .delete(
          "playlists/#{id}/tracks",
          {
            tracks: playlist_items.map do |playlist_item|
              { uri: playlist_item.uri }
            end
          }
        )
      self.snapshot_id = delete_playlist_items_response.body['snapshot_id']
    end

    def add_playlist_items!(uris)
      create_playlist_items_response =
        SPOTIFY_CONNECTION
        .post(
          "playlists/#{id}/tracks",
          { uris: }
        )
      self.snapshot_id = create_playlist_items_response.body['snapshot_id']
    end

    def snapshot_id=(snapshot_id)
      super
      @playlist_items = nil
    end
  end
end
