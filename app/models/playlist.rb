# frozen_string_literal: true

class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_syncs, dependent: :destroy
  has_one :latest_playlist_sync, -> { latest }, class_name: 'PlaylistSync', inverse_of: :playlist, dependent: nil

  validates :name, presence: true
  validates :max_tempo, :min_tempo, presence: true, numericality: true

  after_create -> { delay.sync! }

  def sync!
    playlist_syncs.create!
  end

  def spotify_playlist
    @spotify_playlist ||= find_or_create_spotify_playlist!
  end

  def find_or_create_spotify_playlist!
    user.authenticated do
      return Spotify::Playlist.find(spotify_playlist_id) if spotify_playlist_id.present?

      Playlist.create!(name, public: false).tap do |spotify_playlist|
        update! spotify_playlist_id: spotify_playlist.id
      end
    end
  end
end
