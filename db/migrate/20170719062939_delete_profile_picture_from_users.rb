class DeleteProfilePictureFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :profile_picture
  end
end
