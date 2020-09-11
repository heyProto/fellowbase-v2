class CreateRefCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_countries do |t|
      t.string :name
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
