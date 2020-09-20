class AddPlaylistSyncReferencesToOtherSyncs < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_syncs, :playlist_sync, null: false, foreign_key: true, index: { unique: true }
    add_reference :audio_features_syncs, :playlist_sync, null: false, foreign_key: true, index: { unique: true }
  end
end
