class CreateEventDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :event_digital_assets do |t|
      t.references :event, foreign_key: true
      t.references :digital_asset, foreign_key: true

      t.timestamps
    end
  end
end
