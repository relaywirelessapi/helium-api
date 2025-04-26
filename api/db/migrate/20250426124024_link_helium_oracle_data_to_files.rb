class LinkHeliumOracleDataToFiles < ActiveRecord::Migration[8.0]
  def change
    %i[
      helium_l2_iot_reward_shares
      helium_l2_mobile_reward_shares
      helium_l2_iot_beacon_ingest_reports
      helium_l2_iot_witness_ingest_reports
      helium_l2_reward_manifests
    ].each do |table|
      add_column table, :file_category, :string
      add_column table, :file_name, :string

      add_index table, [ :file_category, :file_name ]
    end
  end
end
