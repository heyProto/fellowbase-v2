class AddIsActiveToRefPartners < ActiveRecord::Migration[5.1]
  def change
    add_column :ref_partners, :is_active, :boolean
  end
end
