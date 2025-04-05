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

ActiveRecord::Schema[8.0].define(version: 2025_04_05_143220) do
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

  create_table "helium_l2_iot_beacon_ingest_reports", id: false, force: :cascade do |t|
    t.datetime "received_at"
    t.string "hotspot_key"
    t.binary "data"
    t.datetime "reported_at"
    t.bigint "tmst"
    t.bigint "frequency"
    t.string "data_rate"
    t.bigint "tx_power"
    t.binary "local_entropy"
    t.binary "remote_entropy"
    t.binary "signature"
    t.string "deduplication_key", null: false
    t.index ["deduplication_key"], name: "index_helium_l2_iot_beacon_ingest_reports_on_deduplication_key", unique: true
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
    t.index ["hotspot_key"], name: "index_helium_l2_iot_reward_shares_on_hotspot_key"
    t.index ["reward_type"], name: "index_helium_l2_iot_reward_shares_on_reward_type"
    t.index ["start_period", "end_period"], name: "idx_on_start_period_end_period_65a8c97b27"
  end

  create_table "helium_l2_iot_witness_ingest_reports", id: false, force: :cascade do |t|
    t.datetime "received_at"
    t.string "hotspot_key"
    t.binary "data"
    t.datetime "reported_at"
    t.bigint "tmst"
    t.bigint "signal"
    t.bigint "snr"
    t.bigint "frequency"
    t.string "data_rate"
    t.binary "signature"
    t.string "deduplication_key", null: false
    t.index ["deduplication_key"], name: "idx_on_deduplication_key_ba179087f7", unique: true
  end

  create_table "helium_l2_mobile_reward_shares", id: false, force: :cascade do |t|
    t.string "owner_key"
    t.string "hotspot_key"
    t.string "cbsd_id"
    t.bigint "amount"
    t.datetime "start_period"
    t.datetime "end_period"
    t.string "reward_type"
    t.bigint "dc_transfer_reward"
    t.bigint "poc_reward"
    t.string "subscriber_id"
    t.bigint "subscriber_reward"
    t.bigint "discovery_location_amount"
    t.string "unallocated_reward_type"
    t.string "service_provider_id"
    t.string "deduplication_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "base_coverage_points_sum", precision: 20, scale: 8
    t.decimal "boosted_coverage_points_sum", precision: 20, scale: 8
    t.decimal "base_reward_shares", precision: 20, scale: 8
    t.decimal "boosted_reward_shares", precision: 20, scale: 8
    t.bigint "base_poc_reward"
    t.bigint "boosted_poc_reward"
    t.bigint "seniority_timestamp"
    t.binary "coverage_object"
    t.decimal "location_trust_score_multiplier", precision: 20, scale: 8
    t.decimal "speedtest_multiplier", precision: 20, scale: 8
    t.integer "sp_boosted_hex_status"
    t.integer "oracle_boosted_hex_status"
    t.string "entity"
    t.bigint "service_provider_amount"
    t.bigint "matched_amount"
    t.index ["deduplication_key"], name: "index_helium_l2_mobile_reward_shares_on_deduplication_key", unique: true
    t.index ["hotspot_key"], name: "index_helium_l2_mobile_reward_shares_on_hotspot_key"
    t.index ["reward_type"], name: "index_helium_l2_mobile_reward_shares_on_reward_type"
    t.index ["start_period", "end_period"], name: "idx_on_start_period_end_period_b04efac248"
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
    t.integer "current_api_usage", default: 0, null: false
    t.datetime "api_usage_reset_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["api_usage_reset_at"], name: "index_users_on_api_usage_reset_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
