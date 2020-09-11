class UpdateIsActiveFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :is_active, :boolean, default: true
  end
end
