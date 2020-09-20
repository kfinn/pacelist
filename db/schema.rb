# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_20_211149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_features_syncs", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "playlist_sync_id", null: false
    t.index ["playlist_sync_id"], name: "index_audio_features_syncs_on_playlist_sync_id", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "playlist_syncs", force: :cascade do |t|
    t.bigint "playlist_id", null: false
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["playlist_id"], name: "index_playlist_syncs_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "min_tempo", null: false
    t.integer "max_tempo", null: false
    t.string "spotify_playlist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "saved_tracks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["track_id"], name: "index_saved_tracks_on_track_id"
    t.index ["user_id"], name: "index_saved_tracks_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "spotify_track_id", null: false
    t.integer "tempo"
    t.datetime "audio_features_synced_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["spotify_track_id"], name: "index_tracks_on_spotify_track_id", unique: true
  end

  create_table "user_syncs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "current_offset", default: 0, null: false
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "playlist_sync_id", null: false
    t.index ["playlist_sync_id"], name: "index_user_syncs_on_playlist_sync_id", unique: true
    t.index ["user_id"], name: "index_user_syncs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "spotify_credential_token", null: false
    t.string "spotify_credential_refresh_token", null: false
    t.datetime "spotify_credential_expires_at", null: false
    t.boolean "spotify_credential_expires", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "audio_features_syncs", "playlist_syncs"
  add_foreign_key "playlist_syncs", "playlists"
  add_foreign_key "playlists", "users"
  add_foreign_key "saved_tracks", "tracks"
  add_foreign_key "saved_tracks", "users"
  add_foreign_key "user_syncs", "playlist_syncs"
  add_foreign_key "user_syncs", "users"
end
