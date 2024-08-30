# frozen_string_literal: true

class CreateAudioFeaturesSyncs < ActiveRecord::Migration[7.2]
  def change
    create_table :audio_features_syncs do |t|
      t.datetime :completed_at

      t.timestamps
    end
  end
end
