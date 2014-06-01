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

ActiveRecord::Schema.define(version: 20140531232347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "core_courses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_courses", ["name"], name: "index_core_courses_on_name", using: :btree

  create_table "dataset_entries", force: true do |t|
    t.integer  "role_id"
    t.string   "data"
    t.integer  "dataset_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "datasets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "creator_id"
    t.integer  "program_id"
    t.integer  "resque_attempts",         default: 0
  end

  add_index "datasets", ["creator_id"], name: "index_datasets_on_creator_id", using: :btree
  add_index "datasets", ["program_id"], name: "index_datasets_on_program_id", using: :btree
  add_index "datasets", ["resque_attempts"], name: "index_datasets_on_resque_attempts", using: :btree

  create_table "errors", force: true do |t|
    t.string   "resource",   default: ""
    t.string   "comment",    default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "errors", ["resource"], name: "index_errors_on_resource", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "invitations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "program_id"
    t.integer  "user_level",       default: 0
    t.string   "slug"
    t.integer  "status",           default: 0
    t.text     "recipient_emails", default: ""
    t.string   "name",             default: ""
    t.boolean  "saved",            default: false
  end

  add_index "invitations", ["creator_id"], name: "index_invitations_on_creator_id", using: :btree
  add_index "invitations", ["program_id"], name: "index_invitations_on_program_id", using: :btree
  add_index "invitations", ["slug"], name: "index_invitations_on_slug", unique: true, using: :btree
  add_index "invitations", ["status"], name: "index_invitations_on_status", using: :btree

  create_table "invites", force: true do |t|
    t.integer  "invitation_id"
    t.string   "code"
    t.string   "email"
    t.integer  "user_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "student_id"
    t.string   "slug"
    t.integer  "status",          default: 0
    t.integer  "resque_attempts", default: 0
    t.integer  "recipient_id"
  end

  add_index "invites", ["invitation_id"], name: "index_invites_on_invitation_id", using: :btree
  add_index "invites", ["recipient_id"], name: "index_invites_on_recipient_id", using: :btree
  add_index "invites", ["resque_attempts"], name: "index_invites_on_resque_attempts", using: :btree
  add_index "invites", ["slug"], name: "index_invites_on_slug", unique: true, using: :btree
  add_index "invites", ["status"], name: "index_invites_on_status", using: :btree

  create_table "programs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "programs", ["slug"], name: "index_programs_on_slug", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.string   "student_id"
  end

  add_index "roles", ["level"], name: "index_roles_on_level", using: :btree
  add_index "roles", ["program_id"], name: "index_roles_on_program_id", using: :btree
  add_index "roles", ["student_id"], name: "index_roles_on_student_id", using: :btree
  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "student_entries", force: true do |t|
    t.string   "email",         default: ""
    t.string   "student_id",    default: ""
    t.integer  "invitation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "saved",         default: false
    t.string   "slug"
  end

  add_index "student_entries", ["invitation_id"], name: "index_student_entries_on_invitation_id", using: :btree
  add_index "student_entries", ["slug"], name: "index_student_entries_on_slug", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "superuser",              default: false
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["superuser"], name: "index_users_on_superuser", using: :btree

end
