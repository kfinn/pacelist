# frozen_string_literal: true

class Track < ApplicationRecord
  def self.without_synced_audio_features
    where audio_features_synced_at: nil
  end

  def self.find_or_create_from_spotify_track!(spotify_track)
    find_or_create_by!(
      spotify_track_id: spotify_track.id
    )
  end

  def spotify_track_uri
    "spotify:track:#{spotify_track_id}"
  end
end
