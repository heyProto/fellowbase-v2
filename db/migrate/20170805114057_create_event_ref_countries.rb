class CreateEventRefCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :event_ref_countries do |t|
      t.references :event, foreign_key: true
      t.references :ref_country, foreign_key: true

      t.timestamps
    end
  end
end
