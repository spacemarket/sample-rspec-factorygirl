class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps null: false
    end
  end
end
