class CreateTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :tracks do |t|
      t.string :spotify_track_id, null: false
      t.integer :tempo
      t.datetime :audio_features_synced_at

      t.timestamps

      t.index :spotify_track_id, unique: true
    end
  end
end
