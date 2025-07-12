class CreateWebhooks < ActiveRecord::Migration[8.0]
  def change
    create_table :webhooks, id: :uuid do |t|
      t.string :source, null: false
      t.jsonb :payload, null: false
      t.datetime :processed_at

      t.index :source
    end
  end
end
