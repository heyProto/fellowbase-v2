class CreateEventRefImpacts < ActiveRecord::Migration[5.1]
  def change
    create_table :event_ref_impacts do |t|
      t.references :event, foreign_key: true
      t.references :ref_impact, foreign_key: true

      t.timestamps
    end
  end
end
