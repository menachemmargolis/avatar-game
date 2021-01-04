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

ActiveRecord::Schema.define(version: 2021_01_04_190033) do

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.integer "element_id"
    t.string "nation"
  end

  create_table "elements", force: :cascade do |t|
    t.string "name"
    t.string "skill_1"
    t.string "skill_2"
    t.string "skill_3"
    t.string "skill_4"
  end

  create_table "games", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user2_id"
    t.integer "character_id"
    t.integer "character_id2"
    t.boolean "result"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

end
