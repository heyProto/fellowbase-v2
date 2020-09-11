class AddIsActiveToRefImpacts < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_impacts, :is_active, :boolean
  end
end
