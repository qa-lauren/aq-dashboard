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

ActiveRecord::Schema.define(version: 2019_10_24_045504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.string "env"
    t.integer "test_id"
    t.string "status"
    t.integer "last_number"
    t.datetime "last_time"
    t.integer "success_number"
    t.datetime "success_time"
    t.integer "stability"
    t.integer "last_duration"
    t.integer "ave_duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["test_id"], name: "index_builds_on_test_id"
  end

  create_table "environment_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "jira_number"
    t.string "body"
    t.string "build_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "tag_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.string "job_url"
    t.boolean "parameterized"
    t.integer "app_tag_id"
    t.integer "feature_tag_id"
    t.integer "owner_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "app_tag_id"], name: "index_tests_on_name_and_app_tag_id"
  end

end
