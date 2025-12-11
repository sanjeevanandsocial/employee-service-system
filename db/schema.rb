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

ActiveRecord::Schema[7.2].define(version: 2025_12_10_132528) do
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

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "address_type"
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name", null: false
    t.date "date", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_holidays_on_date", unique: true
  end

  create_table "leave_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "from_date", null: false
    t.date "to_date", null: false
    t.text "reason", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reporting_person_id"
    t.index ["reporting_person_id"], name: "index_leave_requests_on_reporting_person_id"
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "od_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "from_date", null: false
    t.date "to_date", null: false
    t.text "reason", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reporting_person_id"
    t.index ["reporting_person_id"], name: "index_od_requests_on_reporting_person_id"
    t.index ["user_id"], name: "index_od_requests_on_user_id"
  end

  create_table "project_employees", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_project_employees_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_project_employees_on_project_id"
    t.index ["user_id"], name: "index_project_employees_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.string "status", default: "planned"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_activities", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_activities_on_task_id"
    t.index ["user_id"], name: "index_task_activities_on_user_id"
  end

  create_table "task_filters", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.text "filter_params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_task_filters_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "assigned_to_id"
    t.integer "created_by_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "priority", default: 0
    t.date "due_date"
    t.integer "status", default: 0
    t.integer "category", default: 0
    t.string "estimated_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_tasks_on_assigned_to_id"
    t.index ["created_by_id"], name: "index_tasks_on_created_by_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "permission_key", null: false
    t.string "permission_value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "permission_key"], name: "index_user_permissions_on_user_id_and_permission_key", unique: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 1
    t.boolean "is_frozen", default: false
    t.integer "gender", default: 0, null: false
    t.integer "age"
    t.integer "reporting_person_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reporting_person_id"], name: "index_users_on_reporting_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "leave_requests", "users"
  add_foreign_key "od_requests", "users"
  add_foreign_key "project_employees", "projects"
  add_foreign_key "project_employees", "users"
  add_foreign_key "task_activities", "tasks"
  add_foreign_key "task_activities", "users"
  add_foreign_key "task_filters", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users", column: "assigned_to_id"
  add_foreign_key "tasks", "users", column: "created_by_id"
  add_foreign_key "user_permissions", "users"
end
