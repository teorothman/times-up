# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_13_092507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "avatars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "code"
    t.string "url"
    t.boolean "is_default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_turn_point", default: 0
  end

  create_table "games_statuses", force: :cascade do |t|
    t.string "status", default: "pre_lobby"
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "turn_status", default: "player_selected"
    t.datetime "start_time"
    t.boolean "card_skipped", default: false
    t.integer "current_player"
    t.integer "turn_counter", default: 0
    t.boolean "team1_starting", default: false
    t.index ["game_id"], name: "index_games_statuses_on_game_id"
  end

  create_table "round_cards", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_guessed", default: false
    t.index ["card_id"], name: "index_round_cards_on_card_id"
    t.index ["round_id"], name: "index_round_cards_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "round_number", default: 1
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points_team1", default: 0
    t.integer "points_team2", default: 0
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.bigint "game_id", null: false
    t.boolean "is_creator"
    t.bigint "team_id", null: false
    t.integer "points_round_1", default: 0
    t.integer "points_round_2", default: 0
    t.integer "points_round_3", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_points", default: 0
    t.boolean "is_ready", default: false
    t.bigint "avatar_id"
    t.index ["avatar_id"], name: "index_users_on_avatar_id"
    t.index ["game_id"], name: "index_users_on_game_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cards", "users"
  add_foreign_key "games_statuses", "games"
  add_foreign_key "round_cards", "cards"
  add_foreign_key "round_cards", "rounds"
  add_foreign_key "rounds", "games"
  add_foreign_key "teams", "games"
  add_foreign_key "users", "avatars"
  add_foreign_key "users", "games"
  add_foreign_key "users", "teams"
end
