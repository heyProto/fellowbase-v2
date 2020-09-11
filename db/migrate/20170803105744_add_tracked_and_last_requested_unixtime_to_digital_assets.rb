class AddTrackedAndLastRequestedUnixtimeToDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :digital_assets, :tracked, :boolean
    add_column :digital_assets, :last_requested_unixtime, :bigint
    add_column :digital_assets, :custom_errors, :text
  end
end
