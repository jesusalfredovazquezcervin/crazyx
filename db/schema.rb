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

ActiveRecord::Schema[7.0].define(version: 2023_08_09_222514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "couples", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.integer "mate_id", null: false
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_couples_on_event_id"
    t.index ["player_id"], name: "index_couples_on_player_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "eventDate"
    t.integer "people"
    t.string "status"
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.time "timeIni"
    t.time "timeEnd"
    t.boolean "mixed"
    t.integer "level"
    t.boolean "public"
    t.boolean "message_sent"
    t.index ["player_id"], name: "index_events_on_player_id"
  end

  create_table "match_players", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "request"
    t.boolean "confirmed"
    t.datetime "confirmation_date"
    t.index ["event_id"], name: "index_match_players_on_event_id"
    t.index ["player_id"], name: "index_match_players_on_player_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.integer "playerOne"
    t.integer "pointsOne"
    t.integer "playerTwo"
    t.integer "pointsTwo"
    t.integer "playerThree"
    t.integer "pointsThree"
    t.integer "playerFour"
    t.integer "pointsFour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round"
    t.index ["event_id"], name: "index_matches_on_event_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "number"
    t.string "body"
    t.string "error"
    t.string "action"
    t.string "controller"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.decimal "cost", precision: 10, scale: 2
    t.decimal "retainer", precision: 10, scale: 2
    t.string "payment_type"
    t.string "reference"
    t.string "comments"
    t.datetime "payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_payments_on_event_id"
    t.index ["player_id"], name: "index_payments_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "category"
    t.boolean "leftHanded"
    t.date "birthDate"
    t.integer "eventScore"
    t.integer "totalScore"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cellphone"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_results_on_event_id"
    t.index ["player_id"], name: "index_results_on_player_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "player_id", null: false
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["event_id"], name: "index_scores_on_event_id"
    t.index ["player_id"], name: "index_scores_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.bigint "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["player_id"], name: "index_users_on_player_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verification_codes", force: :cascade do |t|
    t.integer "code"
    t.boolean "used"
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id", null: false
    t.index ["event_id"], name: "index_verification_codes_on_event_id"
    t.index ["player_id"], name: "index_verification_codes_on_player_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "couples", "events"
  add_foreign_key "couples", "players"
  add_foreign_key "couples", "players", column: "mate_id"
  add_foreign_key "events", "players"
  add_foreign_key "match_players", "events"
  add_foreign_key "match_players", "players"
  add_foreign_key "matches", "events"
  add_foreign_key "payments", "events"
  add_foreign_key "payments", "players"
  add_foreign_key "results", "events"
  add_foreign_key "results", "players"
  add_foreign_key "scores", "events"
  add_foreign_key "scores", "players"
  add_foreign_key "verification_codes", "events"
  add_foreign_key "verification_codes", "players"
end
