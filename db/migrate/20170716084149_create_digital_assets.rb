class CreateDigitalAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :digital_assets do |t|
      t.string :asset
      t.string :headline
      t.string :publication
      t.date :publish_date
      t.string :post_type

      t.timestamps
    end
  end
end
