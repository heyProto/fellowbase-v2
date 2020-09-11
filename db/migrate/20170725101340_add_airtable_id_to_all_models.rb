class AddAirtableIdToAllModels < ActiveRecord::Migration[5.1]
  def change
    tables = [:digital_assets,
              :events,
              :projects,
              :ref_countries,
              :ref_impacts,
              :ref_partners,
              :ref_targets,
              :users]

    tables.each do |table_name|
      add_column table_name, :airtable_id, :string
    end
  end
end
