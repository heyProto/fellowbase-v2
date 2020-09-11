class CreateAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.references :user
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :profile_page

      t.timestamps
    end
  end
end
