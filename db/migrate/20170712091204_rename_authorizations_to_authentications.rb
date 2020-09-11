class RenameAuthorizationsToAuthentications < ActiveRecord::Migration[5.1]
  def change
    rename_table :authorizations, :authentications
  end
end
