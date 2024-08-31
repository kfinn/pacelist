# frozen_string_literal: true

module Spotify
  class AudioFeatures
    def self.where(ids:)
      SPOTIFY_CONNECTION
        .get('audio-features', { ids: })
        .body
        .fetch('audio_features')
        .map { |attributes| new(attributes.slice('id')) }
    end

    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :string
    attribute :tempo, :float
  end
end
