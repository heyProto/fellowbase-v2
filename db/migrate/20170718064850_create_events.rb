class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :description
      t.boolean :is_confidential
      t.date :event_date
      t.boolean :is_review_required
      t.string :notes

      t.timestamps
    end
  end
end
