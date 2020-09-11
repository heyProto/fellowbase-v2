class CreateRefImpacts < ActiveRecord::Migration[5.1]
  def change
    create_table :ref_impacts do |t|
      t.string :name
      t.string :genre
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
