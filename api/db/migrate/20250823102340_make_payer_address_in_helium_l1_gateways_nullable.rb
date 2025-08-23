class MakePayerAddressInHeliumL1GatewaysNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :helium_l1_gateways, :payer_address, true
  end
end
