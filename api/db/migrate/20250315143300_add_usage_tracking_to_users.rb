class AddUsageTrackingToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :current_api_usage, :integer, null: false, default: 0
    add_column :users, :api_usage_reset_at, :datetime
    add_index :users, :api_usage_reset_at

    reversible do |dir|
      dir.up do
        User.update_all api_usage_reset_at: Time.current
      end
    end

    change_column_null :users, :api_usage_reset_at, false
  end
end
