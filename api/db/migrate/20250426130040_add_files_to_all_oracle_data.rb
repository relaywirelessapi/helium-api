class AddFilesToAllOracleData < ActiveRecord::Migration[8.0]
  def change
    %i[
      helium_l2_iot_beacon_ingest_reports
      helium_l2_iot_witness_ingest_reports
      helium_l2_iot_reward_shares
      helium_l2_mobile_reward_shares
      helium_l2_reward_manifests
    ].each do |table|
      execute "TRUNCATE TABLE #{table}"

      change_column_null table, :file_category, false
      change_column_null table, :file_name, false
    end

    execute "UPDATE helium_l2_files SET position = 0, started_at = NULL, completed_at = NULL"
  end
end
