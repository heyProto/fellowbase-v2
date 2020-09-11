class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :string, default: "fellow"
  end
end
