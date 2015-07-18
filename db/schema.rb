# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150718181735) do

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.decimal  "lat",           precision: 15, scale: 10, default: 0.0
    t.decimal  "long",          precision: 15, scale: 10, default: 0.0
    t.integer  "tournament_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "polygon"
  end

  add_index "fields", ["tournament_id"], name: "index_fields_on_tournament_id"

  create_table "games", force: :cascade do |t|
    t.integer  "home_id"
    t.integer  "away_id"
    t.integer  "home_score",      default: 0
    t.integer  "away_score",      default: 0
    t.datetime "start_time"
    t.boolean  "score_confirmed"
    t.integer  "field_id"
    t.integer  "tournament_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "games", ["field_id"], name: "index_games_on_field_id"
  add_index "games", ["tournament_id"], name: "index_games_on_tournament_id"

  create_table "maps", force: :cascade do |t|
    t.integer "tournament_id"
    t.decimal "lat",           precision: 15, scale: 10, default: 56.0,  null: false
    t.decimal "long",          precision: 15, scale: 10, default: -96.0, null: false
    t.integer "zoom",                                    default: 4,     null: false
  end

  create_table "score_reports", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "game_id"
    t.integer  "team_id"
    t.string   "submitter_fingerprint"
    t.integer  "team_score",            limit: 2
    t.integer  "opponent_score",        limit: 2
    t.integer  "rules_knowledge",       limit: 1
    t.integer  "fouls",                 limit: 1
    t.integer  "fairness",              limit: 1
    t.integer  "attitude",              limit: 1
    t.integer  "communication",         limit: 1
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "sms"
    t.string   "twitter"
    t.string   "division"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "teams", ["tournament_id"], name: "index_teams_on_tournament_id"

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "handle"
  end

end
