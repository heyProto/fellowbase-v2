class CreateRefPartners < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_partners do |t|
      t.string :name
      t.references :ref_country, foreign_key: true
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
