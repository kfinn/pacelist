# frozen_string_literal: true

class SavedTrack < ApplicationRecord
  belongs_to :user
  belongs_to :track

  def self.find_or_create_from_spotify_saved_track!(spotify_saved_track)
    find_or_create_by!(
      track: Track.find_or_create_from_spotify_track!(spotify_saved_track)
    )
  end
end
