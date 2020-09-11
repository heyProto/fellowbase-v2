class AddIsActiveToRefCountries < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_countries, :is_active, :boolean
  end
end
