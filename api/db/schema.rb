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

ActiveRecord::Schema[8.0].define(version: 2025_07_06_165156) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "uuid-ossp"

  create_table "helium_l2_files", primary_key: ["category", "name"], force: :cascade do |t|
    t.string "definition_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.bigint "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", null: false
    t.string "name", null: false
    t.datetime "download_started_at"
    t.datetime "download_completed_at"
    t.datetime "import_started_at"
    t.datetime "import_completed_at"
    t.index ["category", "name"], name: "index_helium_l2_files_on_category_and_name", unique: true
    t.index ["category"], name: "index_helium_l2_files_on_category"
    t.index ["name"], name: "index_helium_l2_files_on_name"
  end

  create_table "helium_l2_iot_beacon_ingest_reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.string "file_category", null: false
    t.string "file_name", null: false
    t.index ["deduplication_key"], name: "index_helium_l2_iot_beacon_ingest_reports_on_deduplication_key", unique: true
    t.index ["file_category", "file_name"], name: "idx_on_file_category_file_name_42ad2551ea"
  end

  create_table "helium_l2_iot_reward_shares", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "reward_type"
    t.datetime "start_period"
    t.datetime "end_period"
    t.string "hotspot_key"
    t.decimal "beacon_amount", precision: 20
    t.decimal "witness_amount", precision: 20
    t.decimal "dc_transfer_amount", precision: 20
    t.decimal "amount", precision: 20
    t.string "unallocated_reward_type"
    t.string "deduplication_key", null: false
    t.string "file_category", null: false
    t.string "file_name", null: false
    t.index ["deduplication_key"], name: "index_helium_l2_iot_reward_shares_on_deduplication_key", unique: true
    t.index ["file_category", "file_name"], name: "idx_on_file_category_file_name_b2d1df30e4"
    t.index ["hotspot_key"], name: "index_helium_l2_iot_reward_shares_on_hotspot_key"
    t.index ["reward_type"], name: "index_helium_l2_iot_reward_shares_on_reward_type"
    t.index ["start_period", "end_period"], name: "idx_on_start_period_end_period_65a8c97b27"
  end

  create_table "helium_l2_iot_witness_ingest_reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.string "file_category", null: false
    t.string "file_name", null: false
    t.index ["deduplication_key"], name: "idx_on_deduplication_key_ba179087f7", unique: true
    t.index ["file_category", "file_name"], name: "idx_on_file_category_file_name_016ec07462"
  end

  create_table "helium_l2_makers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address", null: false
    t.string "update_authority", null: false
    t.string "issuing_authority", null: false
    t.string "name", null: false
    t.integer "bump_seed", null: false
    t.string "collection", null: false
    t.string "merkle_tree", null: false
    t.integer "collection_bump_seed", null: false
    t.string "dao", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "helium_l2_mobile_reward_shares", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "owner_key"
    t.string "hotspot_key"
    t.string "cbsd_id"
    t.decimal "amount", precision: 20
    t.datetime "start_period"
    t.datetime "end_period"
    t.string "reward_type"
    t.decimal "dc_transfer_reward", precision: 20
    t.decimal "poc_reward", precision: 20
    t.string "subscriber_id"
    t.decimal "subscriber_reward", precision: 20
    t.decimal "discovery_location_amount", precision: 20
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
    t.binary "coverage_object"
    t.decimal "location_trust_score_multiplier", precision: 20, scale: 8
    t.decimal "speedtest_multiplier", precision: 20, scale: 8
    t.string "sp_boosted_hex_status"
    t.string "oracle_boosted_hex_status"
    t.string "entity"
    t.decimal "service_provider_amount", precision: 20
    t.decimal "matched_amount", precision: 20
    t.string "file_category", null: false
    t.string "file_name", null: false
    t.datetime "seniority_timestamp"
    t.index ["deduplication_key"], name: "index_helium_l2_mobile_reward_shares_on_deduplication_key", unique: true
    t.index ["file_category", "file_name"], name: "idx_on_file_category_file_name_2579294e1e"
    t.index ["hotspot_key"], name: "index_helium_l2_mobile_reward_shares_on_hotspot_key"
    t.index ["reward_type"], name: "index_helium_l2_mobile_reward_shares_on_reward_type"
    t.index ["start_period", "end_period"], name: "idx_on_start_period_end_period_b04efac248"
  end

  create_table "helium_l2_reward_manifest_files", id: false, force: :cascade do |t|
    t.uuid "reward_manifest_id", null: false
    t.string "file_name", null: false
    t.index ["file_name"], name: "index_helium_l2_reward_manifest_files_on_file_name"
    t.index ["reward_manifest_id", "file_name"], name: "idx_on_reward_manifest_id_file_name_21a7838b6c", unique: true
  end

  create_table "helium_l2_reward_manifests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "written_files", array: true
    t.datetime "start_timestamp"
    t.datetime "end_timestamp"
    t.jsonb "reward_data"
    t.bigint "epoch"
    t.bigint "price"
    t.string "deduplication_key", null: false
    t.string "file_category", null: false
    t.string "file_name", null: false
    t.index ["deduplication_key"], name: "index_helium_l2_reward_manifests_on_deduplication_key", unique: true
    t.index ["end_timestamp"], name: "index_helium_l2_reward_manifests_on_end_timestamp"
    t.index ["file_category", "file_name"], name: "idx_on_file_category_file_name_02f1bf3b37"
    t.index ["start_timestamp"], name: "index_helium_l2_reward_manifests_on_start_timestamp"
    t.index ["written_files"], name: "index_helium_l2_reward_manifests_on_written_files", using: :gin
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

  create_table "webhooks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "source", null: false
    t.jsonb "payload", null: false
    t.datetime "processed_at"
    t.index ["source"], name: "index_webhooks_on_source"
  end

  add_foreign_key "helium_l2_reward_manifest_files", "helium_l2_reward_manifests", column: "reward_manifest_id", on_delete: :cascade
end
