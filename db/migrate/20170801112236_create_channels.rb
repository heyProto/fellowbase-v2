class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    # channel_keys = [:channel_id,
    #                 :name,
    #                 :unique_id_token,
    #                 :description,
    #                 :creation_unixtime,
    #                 :last_update_unixtime,]

    create_table :channels, force: :cascade do |t|
      t.string :channel_id
      t.string :name
      t.string :unique_id_token
      t.string :description
      t.bigint :creation_unixtime
      t.bigint :last_update_unixtime

      t.timestamps
    end
  end
end
