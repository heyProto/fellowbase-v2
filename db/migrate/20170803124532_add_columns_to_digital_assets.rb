class AddColumnsToDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :digital_assets, :last_update_unixtime, :bigint
    add_column :digital_assets, :creation_unixtime, :bigint
  end
end
