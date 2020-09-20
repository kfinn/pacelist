class PlaylistSync < ApplicationRecord
  belongs_to :playlist
  has_one :user, through: :playlist
  has_many :saved_tracks, through: :user
  has_many :tracks, through: :saved_tracks

  has_one :user_sync
  has_one :audio_features_sync

  delegate :spotify_user, to: :user
  delegate :spotify_playlist, to: :playlist

  after_create -> { delay.start_sync! }

  scope :latest, -> { order created_at: :desc }

  def start_sync!
    create_user_sync!(user: user) unless user_sync.present?
  end

  def user_sync_completed!(_user_sync)
    delay.start_audio_features_sync!
  end

  def start_audio_features_sync!
    create_audio_features_sync! unless audio_features_sync.present?
  end

  def audio_features_sync_completed!(_audio_features_sync)
    delay.sync! unless completed?
  end

  def sync!
    remove_existing_tracks!
    add_new_tracks!
    completed!
  end
  
  def remove_existing_tracks!
    tracks = spotify_playlist.tracks
    while tracks.any?
      spotify_playlist.remove_tracks! tracks
      tracks = spotify_playlist.tracks
    end
  end

  def add_new_tracks!
    spotify_playlist.add_tracks! tracks_matching_tempo.map(&:spotify_track_uri)
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
