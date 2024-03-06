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

ActiveRecord::Schema[7.1].define(version: 2024_03_06_112644) do
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
    t.boolean "is_guessed"
    t.boolean "is_skipped"
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
  end

  create_table "games_statuses", force: :cascade do |t|
    t.string "status", default: "pre-lobby"
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_games_statuses_on_game_id"
  end

  create_table "round_cards", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_round_cards_on_card_id"
    t.index ["round_id"], name: "index_round_cards_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "title"
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points_per_team"
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_teams_on_game_id"
  end

  create_table "turns", force: :cascade do |t|
    t.integer "points"
    t.bigint "round_id", null: false
    t.bigint "user_id", null: false
    t.boolean "skip_used"
    t.integer "timer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_turns_on_round_id"
    t.index ["user_id"], name: "index_turns_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.bigint "game_id", null: false
    t.boolean "is_creator"
    t.bigint "team_id", null: false
    t.integer "points_round_1"
    t.integer "points_round_2"
    t.integer "points_round_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  add_foreign_key "turns", "rounds"
  add_foreign_key "turns", "users"
  add_foreign_key "users", "games"
  add_foreign_key "users", "teams"
end
