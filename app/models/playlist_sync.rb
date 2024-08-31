# frozen_string_literal: true

class PlaylistSync < ApplicationRecord
  belongs_to :playlist
  has_one :user, through: :playlist
  has_many :saved_tracks, through: :user
  has_many :tracks, through: :saved_tracks

  has_one :user_sync, dependent: :destroy
  has_one :audio_features_sync, dependent: :destroy

  delegate :spotify_playlist, to: :playlist

  after_create -> { delay.start_sync! }

  scope :latest, -> { order created_at: :desc }

  def start_sync!
    create_user_sync!(user:) if user_sync.blank?
  end

  def user_sync_completed!(_user_sync)
    delay.start_audio_features_sync!
  end

  def start_audio_features_sync!
    create_audio_features_sync! if audio_features_sync.blank?
  end

  def audio_features_sync_completed!(_audio_features_sync)
    delay.sync! unless completed?
  end

  def sync!
    user.authenticated do
      remove_existing_tracks!
      add_new_tracks!
      completed!
    end
  end

  def remove_existing_tracks!
    spotify_playlist.delete_playlist_items! spotify_playlist.playlist_items while spotify_playlist.playlist_items.any?
  end

  def add_new_tracks!
    tracks_matching_tempo.in_batches(of: 10) do |tracks_matching_tempo_batch|
      spotify_playlist.add_playlist_items! tracks_matching_tempo_batch.map(&:spotify_track_uri)
    end
  end

  def tracks_matching_tempo
    tracks.where(tempo: playlist.min_tempo..playlist.max_tempo)
  end

  def completed!
    update! completed_at: Time.zone.now
  end

  def completed?
    completed_at.present?
  end
end
