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

ActiveRecord::Schema[7.0].define(version: 2023_02_02_192522) do
  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "eventDate"
    t.integer "people"
    t.string "status"
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.index ["player_id"], name: "index_events_on_player_id"
  end

  create_table "match_players", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "player_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_match_players_on_event_id"
    t.index ["player_id"], name: "index_match_players_on_player_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "event_id", null: false
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
    t.index ["event_id"], name: "index_matches_on_event_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.boolean "leftHanded"
    t.date "birthDate"
    t.integer "eventScore"
    t.integer "totalScore"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "player_id", null: false
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_scores_on_event_id"
    t.index ["player_id"], name: "index_scores_on_player_id"
  end

  add_foreign_key "events", "players"
  add_foreign_key "match_players", "events"
  add_foreign_key "match_players", "players"
  add_foreign_key "matches", "events"
  add_foreign_key "scores", "events"
  add_foreign_key "scores", "players"
end
