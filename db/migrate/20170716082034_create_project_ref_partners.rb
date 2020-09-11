class CreateProjectRefPartners < ActiveRecord::Migration[5.1]
  def change
    create_table :project_ref_partners do |t|
      t.references :project, foreign_key: true
      t.references :ref_partner, foreign_key: true

      t.timestamps
    end
  end
end
