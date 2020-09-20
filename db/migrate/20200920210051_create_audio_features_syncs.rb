class CreateAudioFeaturesSyncs < ActiveRecord::Migration[6.0]
  def change
    create_table :audio_features_syncs do |t|
      t.datetime :completed_at

      t.timestamps
    end
  end
end
