class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.date :date
      t.integer :event_type

      t.timestamps null: false
    end
  end
end
