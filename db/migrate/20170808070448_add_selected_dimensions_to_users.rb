class AddSelectedDimensionsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :selected_dimensions, :string
  end
end
