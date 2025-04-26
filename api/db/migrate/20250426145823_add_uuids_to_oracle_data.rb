class AddUuidsToOracleData < ActiveRecord::Migration[8.0]
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    %i[helium_l2_mobile_reward_shares helium_l2_iot_reward_shares helium_l2_iot_beacon_ingest_reports helium_l2_iot_witness_ingest_reports helium_l2_reward_manifests].each do |table|
      add_column table, :id, :uuid, null: false, default: "uuid_generate_v4()"
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id)"
    end
  end
end
