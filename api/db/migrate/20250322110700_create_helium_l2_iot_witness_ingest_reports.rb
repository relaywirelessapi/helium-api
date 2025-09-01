class CreateHeliumL2IotWitnessIngestReports < ActiveRecord::Migration[8.0]
  def change
    create_table :helium_l2_iot_witness_ingest_reports, id: false do |t|
      t.datetime :received_at
      t.string :hotspot_key
      t.string :data
      t.datetime :reported_at
      t.bigint :tmst
      t.bigint :signal
      t.bigint :snr
      t.bigint :frequency
      t.string :data_rate
      t.string :signature
      t.string :deduplication_key, index: { unique: true }, null: false
    end
  end
end
