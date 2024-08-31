# frozen_string_literal: true

module Spotify
  class SavedTrack
    def self.where(offset:, limit:)
      SPOTIFY_CONNECTION
        .get('me/tracks', { offset:, limit: })
        .body
        .fetch('items')
        .map do |attributes|
          puts attributes
          new(
            artists: attributes.dig('track', 'artists').map { |artist_attributes| Artist.new(artist_attributes.slice('name')) },
            **attributes.fetch('track').slice('id', 'name')
          )
        end
    end

    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :string
    attribute :name, :string
    attribute :artists

    class Artist
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, :string
    end
  end
end
