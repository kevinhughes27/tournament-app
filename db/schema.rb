# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180523133856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "divisions", force: :cascade do |t|
    t.integer  "tournament_id"
    t.string   "bracket_type",                  null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "name"
    t.integer  "num_teams",     default: 8
    t.integer  "num_days",      default: 2,     null: false
    t.boolean  "seeded",        default: false
    t.index ["tournament_id", "name"], name: "index_divisions_on_tournament_id_and_name", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_divisions_on_tournament_id", using: :btree
  end

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.decimal  "lat",           precision: 15, scale: 10
    t.decimal  "long",          precision: 15, scale: 10
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geo_json"
    t.index ["tournament_id", "name"], name: "index_fields_on_tournament_id_and_name", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_fields_on_tournament_id", using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.integer  "home_id"
    t.integer  "away_id"
    t.integer  "home_score"
    t.integer  "away_score"
    t.datetime "start_time"
    t.boolean  "score_confirmed", default: false, null: false
    t.integer  "field_id"
    t.integer  "tournament_id",                   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "bracket_uid"
    t.string   "home_prereq"
    t.string   "away_prereq"
    t.integer  "division_id",                     null: false
    t.integer  "round"
    t.string   "pool"
    t.string   "home_pool_seed"
    t.string   "away_pool_seed"
    t.integer  "seed_round",      default: 0
    t.datetime "end_time"
    t.index ["tournament_id", "away_id"], name: "index_games_on_tournament_id_and_away_id", using: :btree
    t.index ["tournament_id", "division_id", "away_prereq"], name: "tournament_division_away_prereq_uid", using: :btree
    t.index ["tournament_id", "division_id", "bracket_uid"], name: "index_games_on_tournament_id_and_division_id_and_bracket_uid", unique: true, using: :btree
    t.index ["tournament_id", "division_id", "home_prereq"], name: "tournament_division_home_prereq_uid", using: :btree
    t.index ["tournament_id", "division_id", "pool"], name: "tournament_division_pool", using: :btree
    t.index ["tournament_id", "division_id", "score_confirmed"], name: "tournament_division_confirmed", using: :btree
    t.index ["tournament_id", "field_id"], name: "index_games_on_tournament_id_and_field_id", using: :btree
    t.index ["tournament_id", "home_id"], name: "index_games_on_tournament_id_and_home_id", using: :btree
    t.index ["tournament_id"], name: "index_games_on_tournament_id", using: :btree
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "tournament_id"
    t.decimal  "lat",           precision: 15, scale: 10, default: "56.0",  null: false
    t.decimal  "long",          precision: 15, scale: 10, default: "-96.0", null: false
    t.integer  "zoom",                                    default: 4,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "edited_at"
    t.index ["tournament_id"], name: "index_maps_on_tournament_id", unique: true, using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "division_id",   null: false
    t.integer  "team_id"
    t.integer  "position",      null: false
    t.string   "prereq",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tournament_id", "division_id", "prereq"], name: "index_places_on_tournament_id_and_division_id_and_prereq", using: :btree
  end

  create_table "pool_results", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "division_id",   null: false
    t.integer  "team_id",       null: false
    t.string   "pool",          null: false
    t.integer  "position",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wins",          null: false
    t.integer  "points",        null: false
  end

  create_table "score_disputes", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "user_id"
    t.integer  "game_id",       null: false
    t.string   "status",        null: false
    t.datetime "deleted_at"
    t.index ["tournament_id", "game_id", "deleted_at"], name: "score_dispute_tournament_game_deleted_at", using: :btree
  end

  create_table "score_entries", force: :cascade do |t|
    t.integer  "tournament_id", null: false
    t.integer  "user_id",       null: false
    t.integer  "game_id",       null: false
    t.integer  "home_id",       null: false
    t.integer  "away_id",       null: false
    t.integer  "home_score",    null: false
    t.integer  "away_score",    null: false
    t.datetime "deleted_at"
  end

  create_table "score_reports", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "game_id"
    t.integer  "team_id"
    t.string   "submitter_fingerprint"
    t.integer  "rules_knowledge",       limit: 2
    t.integer  "fouls",                 limit: 2
    t.integer  "fairness",              limit: 2
    t.integer  "attitude",              limit: 2
    t.integer  "communication",         limit: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "comments"
    t.datetime "deleted_at"
    t.boolean  "is_confirmation",                 default: false
    t.integer  "home_score",                                      null: false
    t.integer  "away_score",                                      null: false
    t.index ["tournament_id", "game_id", "deleted_at"], name: "tournament_game_deleted_at", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "seed"
    t.integer  "division_id"
    t.index ["tournament_id", "division_id"], name: "index_teams_on_tournament_id_and_division_id", using: :btree
    t.index ["tournament_id", "name"], name: "index_teams_on_tournament_id_and_name", unique: true, using: :btree
    t.index ["tournament_id"], name: "index_teams_on_tournament_id", using: :btree
  end

  create_table "tournament_users", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_tournament_users_on_tournament_id", using: :btree
    t.index ["user_id", "tournament_id"], name: "index_tournament_users_on_user_id_and_tournament_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_tournament_users_on_user_id", using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "handle"
    t.string   "location"
    t.string   "timezone"
    t.boolean  "welcome_email_sent",   default: false
    t.string   "game_confirm_setting", default: "single"
    t.string   "score_submit_pin"
    t.index ["handle"], name: "index_tournaments_on_handle", unique: true, using: :btree
    t.index ["name"], name: "index_tournaments_on_name", unique: true, using: :btree
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider"], name: "index_user_authentications_on_provider", using: :btree
    t.index ["user_id"], name: "index_user_authentications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
