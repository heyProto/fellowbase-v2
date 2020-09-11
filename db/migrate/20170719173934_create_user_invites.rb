class CreateUserInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :user_invites do |t|
      t.string :email
      t.integer :sender

      t.timestamps
    end
  end
end
