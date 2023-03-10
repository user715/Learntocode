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

ActiveRecord::Schema.define(version: 2023_02_06_075404) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "problem_count", default: 0
  end

  create_table "languages", force: :cascade do |t|
    t.string "language"
    t.string "versionIndex"
    t.string "name"
  end

  create_table "problem_categories", force: :cascade do |t|
    t.integer "problem_id"
    t.integer "category_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "test_cases"
    t.text "test_case_solutions"
    t.text "sample_cases"
    t.text "sample_case_solutions"
    t.integer "likes", default: 0
    t.integer "tag_id"
  end

  create_table "solved_problems", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.text "script"
    t.string "language"
    t.integer "versionIndex"
    t.integer "user_id"
    t.integer "problem_id"
    t.datetime "created_at", precision: 6, null: false
    t.string "status"
    t.string "compiler"
  end

  create_table "tags", force: :cascade do |t|
    t.string "tagname"
    t.integer "problem_count", default: 0
  end

  create_table "user_problem_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "problem_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.integer "easysolved", default: 0
    t.integer "mediumSolved", default: 0
    t.integer "difficultSolved", default: 0
    t.string "password_digest"
    t.integer "rank"
    t.integer "score"
  end

end
