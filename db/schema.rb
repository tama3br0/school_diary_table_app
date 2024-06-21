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

ActiveRecord::Schema[7.1].define(version: 2024_06_21_153737) do
  create_table "diaries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_num", null: false
    t.integer "emotion_num", null: false
    t.index ["user_id"], name: "fk_rails_f03fd03c63"
  end

  create_table "grade_classes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "grade", null: false
    t.integer "class_num", null: false
    t.integer "school_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stamps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "diary_id", null: false
    t.string "stamp_image", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diary_id"], name: "fk_rails_68d32c37ad"
    t.index ["user_id"], name: "fk_rails_64f545624f"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "uid", null: false
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.integer "role", default: 0, null: false
    t.bigint "grade_class_id"
    t.integer "student_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "additional_info_provided"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["grade_class_id"], name: "fk_rails_cb87fe8d12"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "diaries", "users"
  add_foreign_key "stamps", "diaries"
  add_foreign_key "stamps", "users"
  add_foreign_key "users", "grade_classes"
end
