class AddItemIdToDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :digital_assets, :item_id, :integer
  end
end
