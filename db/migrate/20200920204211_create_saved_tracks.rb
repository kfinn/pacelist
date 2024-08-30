# frozen_string_literal: true

class CreateSavedTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :saved_tracks do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :track, null: false, foreign_key: true

      t.timestamps
    end
  end
end
