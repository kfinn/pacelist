class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_syncs
  has_one :latest_playlist_sync, -> { latest }, class_name: 'PlaylistSync', inverse_of: :playlist

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
    return RSpotify::Playlist.find_by_id(spotify_playlist_id) if spotify_playlist_id.present?

    user.spotify_user.create_playlist!(name, public: false).tap do |spotify_playlist|
      update! spotify_playlist_id: spotify_playlist.id
    end
  end
end
