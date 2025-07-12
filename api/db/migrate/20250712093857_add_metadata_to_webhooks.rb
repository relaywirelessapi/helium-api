class AddMetadataToWebhooks < ActiveRecord::Migration[8.0]
  def change
    add_column :webhooks, :metadata, :jsonb, null: false, default: {}
  end
end
