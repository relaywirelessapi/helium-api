class CreateHeliumL2IotBeaconIngestReports < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_iot_beacon_ingest_reports, id: false do |t|
      t.datetime :received_at
      t.string :hotspot_key
      t.string :data
      t.datetime :reported_at
      t.bigint :tmst
      t.bigint :frequency
      t.string :data_rate
      t.bigint :tx_power
      t.binary :local_entropy
      t.binary :remote_entropy
      t.string :signature
      t.string :deduplication_key, index: { unique: true }, null: false
    end
  end
end
