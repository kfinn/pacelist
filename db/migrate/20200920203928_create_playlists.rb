# frozen_string_literal: true

class CreatePlaylists < ActiveRecord::Migration[7.2]
  def change
    create_table :playlists do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :min_tempo, null: false
      t.integer :max_tempo, null: false

      t.string :spotify_playlist_id

      t.timestamps
    end
  end
end
