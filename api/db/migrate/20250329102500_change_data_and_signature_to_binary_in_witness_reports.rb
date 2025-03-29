class ChangeDataAndSignatureToBinaryInWitnessReports < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :helium_l2_iot_witness_ingest_reports, :data, :binary, using: 'data::bytea'
        change_column :helium_l2_iot_witness_ingest_reports, :signature, :binary, using: 'signature::bytea'
      end

      dir.down do
        change_column :helium_l2_iot_witness_ingest_reports, :data, :string, using: 'data::text'
        change_column :helium_l2_iot_witness_ingest_reports, :signature, :string, using: 'signature::text'
      end
    end
  end
end
