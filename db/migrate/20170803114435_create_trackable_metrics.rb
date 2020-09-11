class CreateTrackableMetrics < ActiveRecord::Migration[5.1]
  def change
    create_table :trackable_metrics do |t|
      t.integer :item_id
      t.references :digital_asset, foreign_key: true
      t.string :genre
      t.string :metric_type
      t.integer :value

      t.timestamps
    end
  end
end
