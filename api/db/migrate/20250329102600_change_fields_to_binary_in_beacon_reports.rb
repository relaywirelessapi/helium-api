class ChangeFieldsToBinaryInBeaconReports < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :helium_l2_iot_beacon_ingest_reports, :data, :binary, using: 'data::bytea'
        change_column :helium_l2_iot_beacon_ingest_reports, :signature, :binary, using: 'signature::bytea'
        change_column :helium_l2_iot_beacon_ingest_reports, :local_entropy, :binary, using: 'local_entropy::bytea'
        change_column :helium_l2_iot_beacon_ingest_reports, :remote_entropy, :binary, using: 'remote_entropy::bytea'
      end

      dir.down do
        change_column :helium_l2_iot_beacon_ingest_reports, :data, :string, using: 'data::text'
        change_column :helium_l2_iot_beacon_ingest_reports, :signature, :string, using: 'signature::text'
        change_column :helium_l2_iot_beacon_ingest_reports, :local_entropy, :binary, using: 'local_entropy::bytea'
        change_column :helium_l2_iot_beacon_ingest_reports, :remote_entropy, :binary, using: 'remote_entropy::bytea'
      end
    end
  end
end
