# frozen_string_literal: true

class CreateDeviseUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :provider, null: false
      t.string :uid, null: false

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false

      t.string :spotify_credential_token, null: false
      t.string :spotify_credential_refresh_token, null: false
      t.datetime :spotify_credential_expires_at, null: false
      t.boolean :spotify_credential_expires, null: false, default: false

      t.index %i[provider uid], unique: true
    end
  end
end
