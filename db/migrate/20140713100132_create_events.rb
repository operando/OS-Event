class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :address
      t.date :start_time
      t.date :end_time
      t.string :event_site

      t.timestamps
    end
  end
end
