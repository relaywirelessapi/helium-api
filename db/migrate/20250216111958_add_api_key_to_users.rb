class AddApiKeyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :api_key, :string

    # Generate initial API keys
    reversible do |dir|
      dir.up do
        Relay::User.find_each(&:refresh_api_key!)
      end
    end

    add_index :users, :api_key, unique: true
    change_column_null :users, :api_key, false
  end
end
