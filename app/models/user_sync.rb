class UserSync < ApplicationRecord
  PAGE_SIZE = 50

  belongs_to :user
  belongs_to :playlist_sync

  after_create -> { delay.sync_next_page! }

  def sync_next_page!
    current_page_spotify_saved_tracks = user.spotify_user.saved_tracks(offset: current_offset, limit: PAGE_SIZE)

    if current_page_spotify_saved_tracks.size == 0
      sync_completed!
      return
    end

    transaction do
      current_page_spotify_saved_tracks.each do |spotify_saved_track|
        user.saved_tracks.find_or_create_from_spotify_saved_track!(spotify_saved_track)
      end
      update! current_offset: current_offset + PAGE_SIZE
      delay.sync_next_page!
    end
  end

  def sync_completed!
    update! completed_at: Time.zone.now
    playlist_sync.user_sync_completed! self    
  end
end
