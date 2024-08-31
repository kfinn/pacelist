# frozen_string_literal: true

class AudioFeaturesSync < ApplicationRecord
  BATCH_SIZE = 50

  belongs_to :playlist_sync

  after_create -> { delay.sync_next_batch! }

  def sync_next_batch!
    tracks_batch = Track.without_synced_audio_features.first(BATCH_SIZE)
    if tracks_batch.empty?
      completed!
      return
    end

    audio_features_batch = Spotify::AudioFeatures.where(ids: tracks_batch.map(&:spotify_track_id))

    transaction do
      tracks_batch.zip(audio_features_batch).each do |track, audio_features|
        track.update! tempo: audio_features&.tempo, audio_features_synced_at: Time.zone.now
      end
      delay.sync_next_batch!
    end
  end

  def completed!
    transaction do
      update! completed_at: Time.zone.now
      playlist_sync.audio_features_sync_completed! self
    end
  end
end
