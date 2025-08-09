class InstallPgH3Extension < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'h3'
  end
end
