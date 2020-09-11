class CreateEventRefPartners < ActiveRecord::Migration[5.1]
  def change
    create_table :event_ref_partners do |t|
      t.references :event, foreign_key: true
      t.references :ref_partner, foreign_key: true

      t.timestamps
    end
  end
end
