class CreateTargets < ActiveRecord::Migration[5.1]
  def change
    create_table :targets do |t|
      t.string :name
      t.boolean :is_active

      t.timestamps
    end
  end
end
