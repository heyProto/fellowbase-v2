class AddTypeToDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :digital_assets, :_type, :string
  end
end
