class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.string :image_url
      t.string :billetto_id

      t.timestamps
    end

    add_index :events, :billetto_id, unique: true
  end
end