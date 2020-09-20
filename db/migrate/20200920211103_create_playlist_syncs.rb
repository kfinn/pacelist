class CreatePlaylistSyncs < ActiveRecord::Migration[6.0]
  def change
    create_table :playlist_syncs do |t|
      t.belongs_to :playlist, null: false, foreign_key: true
      t.datetime :completed_at

      t.timestamps
    end
  end
end
