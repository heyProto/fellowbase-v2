class AddChannelIdToDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    add_reference :digital_assets, :channel, foreign_key: true
  end
end
