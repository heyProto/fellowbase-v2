class CreateEventProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :event_projects do |t|
      t.references :event, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
