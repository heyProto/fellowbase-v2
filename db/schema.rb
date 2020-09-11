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

ActiveRecord::Schema.define(version: 20170809070448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string "channel_id"
    t.string "name"
    t.string "unique_id_token"
    t.string "description"
    t.bigint "creation_unixtime"
    t.bigint "last_update_unixtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
  end

  create_table "digital_assets", force: :cascade do |t|
    t.string "asset"
    t.string "headline"
    t.string "publication"
    t.date "publish_date"
    t.string "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "airtable_id"
    t.boolean "tracked"
    t.bigint "last_requested_unixtime"
    t.text "custom_errors"
    t.integer "item_id"
    t.bigint "last_update_unixtime"
    t.bigint "creation_unixtime"
    t.bigint "channel_id"
    t.string "_type"
    t.index ["channel_id"], name: "index_digital_assets_on_channel_id"
  end

  create_table "event_digital_assets", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "digital_asset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digital_asset_id"], name: "index_event_digital_assets_on_digital_asset_id"
    t.index ["event_id"], name: "index_event_digital_assets_on_event_id"
  end

  create_table "event_projects", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_projects_on_event_id"
    t.index ["project_id"], name: "index_event_projects_on_project_id"
  end

  create_table "event_ref_countries", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "ref_country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_ref_countries_on_event_id"
    t.index ["ref_country_id"], name: "index_event_ref_countries_on_ref_country_id"
  end

  create_table "event_ref_impacts", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "ref_impact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_ref_impacts_on_event_id"
    t.index ["ref_impact_id"], name: "index_event_ref_impacts_on_ref_impact_id"
  end

  create_table "event_ref_partners", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "ref_partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_ref_partners_on_event_id"
    t.index ["ref_partner_id"], name: "index_event_ref_partners_on_ref_partner_id"
  end

  create_table "event_users", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_users_on_event_id"
    t.index ["user_id"], name: "index_event_users_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "description"
    t.boolean "is_confidential"
    t.date "event_date"
    t.boolean "is_review_required"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "airtable_id"
  end

  create_table "project_ref_partners", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "ref_partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_ref_partners_on_project_id"
    t.index ["ref_partner_id"], name: "index_project_ref_partners_on_ref_partner_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "airtable_id"
  end

  create_table "ref_countries", force: :cascade do |t|
    t.string "name"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
    t.string "airtable_id"
  end

  create_table "ref_impacts", force: :cascade do |t|
    t.string "name"
    t.string "genre"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
    t.string "airtable_id"
  end

  create_table "ref_partners", force: :cascade do |t|
    t.string "name"
    t.bigint "ref_country_id"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active"
    t.string "airtable_id"
    t.index ["ref_country_id"], name: "index_ref_partners_on_ref_country_id"
  end

  create_table "ref_targets", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "airtable_id"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trackable_metrics", force: :cascade do |t|
    t.integer "item_id"
    t.bigint "digital_asset_id"
    t.string "genre"
    t.string "metric_type"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digital_asset_id"], name: "index_trackable_metrics_on_digital_asset_id"
  end

  create_table "user_invites", force: :cascade do |t|
    t.string "email"
    t.integer "sender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role", default: "fellow"
    t.boolean "is_active", default: true
    t.string "airtable_id"
    t.string "selected_dimensions"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "digital_assets", "channels"
  add_foreign_key "event_digital_assets", "digital_assets"
  add_foreign_key "event_digital_assets", "events"
  add_foreign_key "event_projects", "events"
  add_foreign_key "event_projects", "projects"
  add_foreign_key "event_ref_countries", "events"
  add_foreign_key "event_ref_countries", "ref_countries"
  add_foreign_key "event_ref_impacts", "events"
  add_foreign_key "event_ref_impacts", "ref_impacts"
  add_foreign_key "event_ref_partners", "events"
  add_foreign_key "event_ref_partners", "ref_partners"
  add_foreign_key "event_users", "events"
  add_foreign_key "event_users", "users"
  add_foreign_key "project_ref_partners", "projects"
  add_foreign_key "project_ref_partners", "ref_partners"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "ref_partners", "ref_countries"
  add_foreign_key "trackable_metrics", "digital_assets"
end
