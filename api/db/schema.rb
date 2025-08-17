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

ActiveRecord::Schema[8.0].define(version: 2025_08_17_171947) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "h3"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "uuid-ossp"

  create_table "helium_l1_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address", null: false
    t.bigint "balance", default: 0, null: false
    t.integer "nonce", default: 0, null: false
    t.bigint "dc_balance", default: 0, null: false
    t.integer "dc_nonce", default: 0, null: false
    t.bigint "security_balance", default: 0, null: false
    t.integer "security_nonce", default: 0, null: false
    t.bigint "first_block", null: false
    t.bigint "last_block", null: false
    t.bigint "staked_balance", default: 0, null: false
    t.bigint "mobile_balance", default: 0, null: false
    t.bigint "iot_balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_helium_l1_accounts_on_address", unique: true
    t.index ["first_block"], name: "index_helium_l1_accounts_on_first_block"
    t.index ["last_block"], name: "index_helium_l1_accounts_on_last_block"
  end

  create_table "helium_l1_dc_burns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "block", null: false
    t.string "transaction_hash", null: false
    t.string "actor_address", null: false
    t.string "type", null: false
    t.bigint "amount", null: false
    t.bigint "oracle_price", null: false
    t.bigint "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_address"], name: "index_helium_l1_dc_burns_on_actor_address"
    t.index ["block"], name: "index_helium_l1_dc_burns_on_block"
    t.index ["time"], name: "index_helium_l1_dc_burns_on_time"
    t.index ["transaction_hash"], name: "index_helium_l1_dc_burns_on_transaction_hash"
    t.index ["type"], name: "index_helium_l1_dc_burns_on_type"
  end

  create_table "helium_l1_files", force: :cascade do |t|
    t.string "file_type", null: false
    t.string "file_name", null: false
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_type", "file_name"], name: "index_helium_l1_files_on_file_type_and_file_name", unique: true
  end

  create_table "helium_l1_gateways", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address", null: false
    t.string "owner_address", null: false
    t.string "location"
    t.bigint "last_poc_challenge"
    t.string "last_poc_onion_key_hash"
    t.jsonb "witnesses", default: {}
    t.bigint "first_block", null: false
    t.bigint "last_block", null: false
    t.integer "nonce", default: 0, null: false
    t.string "name", null: false
    t.datetime "first_timestamp", null: false
    t.decimal "reward_scale", precision: 10, scale: 2
    t.integer "elevation", default: 0, null: false
    t.integer "gain", default: 12, null: false
    t.string "location_hex"
    t.string "mode", default: "full", null: false
    t.string "payer_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_helium_l1_gateways_on_address", unique: true
    t.index ["first_block"], name: "index_helium_l1_gateways_on_first_block"
    t.index ["last_block"], name: "index_helium_l1_gateways_on_last_block"
    t.index ["mode"], name: "index_helium_l1_gateways_on_mode"
    t.index ["name"], name: "index_helium_l1_gateways_on_name"
    t.index ["owner_address"], name: "index_helium_l1_gateways_on_owner_address"
    t.index ["payer_address"], name: "index_helium_l1_gateways_on_payer_address"
  end

  create_table "helium_l1_packets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "block", null: false
    t.string "transaction_hash", null: false
    t.bigint "time", null: false
    t.string "gateway_address", null: false
    t.integer "num_packets", null: false
    t.integer "num_dcs", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block"], name: "index_helium_l1_packets_on_block"
    t.index ["gateway_address"], name: "index_helium_l1_packets_on_gateway_address"
    t.index ["time"], name: "index_helium_l1_packets_on_time"
    t.index ["transaction_hash"], name: "index_helium_l1_packets_on_transaction_hash"
  end

  create_table "helium_l1_rewards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "block", null: false
    t.string "transaction_hash", null: false
    t.bigint "time", null: false
    t.string "account_address", null: false
    t.string "gateway_address", null: false
    t.bigint "amount", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_address"], name: "index_helium_l1_rewards_on_account_address"
    t.index ["block"], name: "index_helium_l1_rewards_on_block"
    t.index ["gateway_address"], name: "index_helium_l1_rewards_on_gateway_address"
    t.index ["time"], name: "index_helium_l1_rewards_on_time"
    t.index ["transaction_hash"], name: "index_helium_l1_rewards_on_transaction_hash"
    t.index ["type"], name: "index_helium_l1_rewards_on_type"
  end

  create_table "helium_l1_transaction_actors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "actor_address", null: false
    t.string "actor_role", null: false
    t.string "transaction_hash", null: false
    t.bigint "block", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_address"], name: "index_helium_l1_transaction_actors_on_actor_address"
    t.index ["actor_role"], name: "index_helium_l1_transaction_actors_on_actor_role"
    t.index ["block"], name: "index_helium_l1_transaction_actors_on_block"
    t.index ["transaction_hash", "actor_address"], name: "idx_on_transaction_hash_actor_address_aba6890821", unique: true
    t.index ["transaction_hash"], name: "index_helium_l1_transaction_actors_on_transaction_hash"
  end

  create_table "helium_l1_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "block", null: false
    t.string "transaction_hash", null: false
    t.string "type", null: false
    t.jsonb "fields", default: {}, null: false
    t.bigint "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["block"], name: "index_helium_l1_transactions_on_block"
    t.index ["time"], name: "index_helium_l1_transactions_on_time"
    t.index ["transaction_hash"], name: "index_helium_l1_transactions_on_transaction_hash", unique: true
    t.index ["type"], name: "index_helium_l1_transactions_on_type"
  end

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

  create_table "helium_l2_hotspot_radios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "hotspot_id", null: false
    t.string "radio_id", null: false
    t.integer "elevation", null: false
  end

  create_table "helium_l2_hotspots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "asset_id", null: false
    t.string "ecc_key", null: false
    t.string "owner", null: false
    t.string "networks", null: false, array: true
    t.string "name", null: false
    t.uuid "maker_id", null: false
    t.string "iot_info_address"
    t.integer "iot_bump_seed"
    t.bigint "iot_location"
    t.integer "iot_elevation"
    t.integer "iot_gain"
    t.boolean "iot_is_full_hotspot"
    t.integer "iot_num_location_asserts"
    t.boolean "iot_is_active"
    t.integer "iot_dc_onboarding_fee_paid"
    t.string "mobile_info_address"
    t.integer "mobile_bump_seed"
    t.bigint "mobile_location"
    t.boolean "mobile_is_full_hotspot"
    t.integer "mobile_num_location_asserts"
    t.boolean "mobile_is_active"
    t.integer "mobile_dc_onboarding_fee_paid"
    t.string "mobile_device_type"
    t.integer "mobile_antenna"
    t.integer "mobile_azimuth"
    t.integer "mobile_mechanical_down_tilt"
    t.integer "mobile_electrical_down_tilt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_helium_l2_hotspots_on_asset_id", unique: true
    t.index ["ecc_key"], name: "index_helium_l2_hotspots_on_ecc_key", unique: true
    t.index ["iot_location"], name: "index_helium_l2_hotspots_on_iot_location"
    t.index ["mobile_location"], name: "index_helium_l2_hotspots_on_mobile_location"
    t.index ["networks"], name: "index_helium_l2_hotspots_on_networks", using: :gin
    t.index ["owner"], name: "index_helium_l2_hotspots_on_owner"
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

  create_table "pay_charges", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "subscription_id"
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.string "currency"
    t.integer "application_fee_amount"
    t.integer "amount_refunded"
    t.jsonb "metadata"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["customer_id", "processor_id"], name: "index_pay_charges_on_customer_id_and_processor_id", unique: true
    t.index ["subscription_id"], name: "index_pay_charges_on_subscription_id"
  end

  create_table "pay_customers", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["owner_type", "owner_id", "deleted_at"], name: "pay_customer_owner_index", unique: true
    t.index ["processor", "processor_id"], name: "index_pay_customers_on_processor_and_processor_id", unique: true
  end

  create_table "pay_merchants", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["owner_type", "owner_id", "processor"], name: "index_pay_merchants_on_owner_type_and_owner_id_and_processor"
  end

  create_table "pay_payment_methods", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "processor_id", null: false
    t.boolean "default"
    t.string "payment_method_type"
    t.jsonb "data"
    t.string "stripe_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["customer_id", "processor_id"], name: "index_pay_payment_methods_on_customer_id_and_processor_id", unique: true
  end

  create_table "pay_subscriptions", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "name", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.string "status", null: false
    t.datetime "current_period_start", precision: nil
    t.datetime "current_period_end", precision: nil
    t.datetime "trial_ends_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.boolean "metered"
    t.string "pause_behavior"
    t.datetime "pause_starts_at", precision: nil
    t.datetime "pause_resumes_at", precision: nil
    t.decimal "application_fee_percent", precision: 8, scale: 2
    t.jsonb "metadata"
    t.jsonb "data"
    t.string "stripe_account"
    t.string "payment_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.jsonb "object"
    t.index ["customer_id", "processor_id"], name: "index_pay_subscriptions_on_customer_id_and_processor_id", unique: true
    t.index ["metered"], name: "index_pay_subscriptions_on_metered"
    t.index ["pause_starts_at"], name: "index_pay_subscriptions_on_pause_starts_at"
  end

  create_table "pay_webhooks", force: :cascade do |t|
    t.string "processor"
    t.string "event_type"
    t.jsonb "event"
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
    t.jsonb "metadata", default: {}, null: false
    t.index ["source"], name: "index_webhooks_on_source"
  end

  add_foreign_key "helium_l2_hotspot_radios", "helium_l2_hotspots", column: "hotspot_id", on_delete: :cascade
  add_foreign_key "helium_l2_hotspots", "helium_l2_makers", column: "maker_id"
  add_foreign_key "helium_l2_reward_manifest_files", "helium_l2_reward_manifests", column: "reward_manifest_id", on_delete: :cascade
  add_foreign_key "pay_charges", "pay_customers", column: "customer_id"
  add_foreign_key "pay_charges", "pay_subscriptions", column: "subscription_id"
  add_foreign_key "pay_payment_methods", "pay_customers", column: "customer_id"
  add_foreign_key "pay_subscriptions", "pay_customers", column: "customer_id"
end
