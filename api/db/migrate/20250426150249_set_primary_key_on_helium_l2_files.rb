class SetPrimaryKeyOnHeliumL2Files < ActiveRecord::Migration[8.0]
  def change
    execute "ALTER TABLE helium_l2_files ADD PRIMARY KEY (category, name)"
  end
end
