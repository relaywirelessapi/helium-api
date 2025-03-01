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

ActiveRecord::Schema[8.0].define(version: 2025_03_08_180750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "helium_l2_files", force: :cascade do |t|
    t.string "definition_id", null: false
    t.string "s3_key", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.bigint "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["s3_key"], name: "index_helium_l2_files_on_s3_key", unique: true
  end

  create_table "helium_l2_iot_reward_shares", id: false, force: :cascade do |t|
    t.string "reward_type"
    t.datetime "start_period"
    t.datetime "end_period"
    t.string "hotspot_key"
    t.bigint "beacon_amount"
    t.bigint "witness_amount"
    t.bigint "dc_transfer_amount"
    t.bigint "amount"
    t.string "unallocated_reward_type"
    t.string "deduplication_key", null: false
    t.index ["deduplication_key"], name: "index_helium_l2_iot_reward_shares_on_deduplication_key", unique: true
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
    t.string "api_key", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
