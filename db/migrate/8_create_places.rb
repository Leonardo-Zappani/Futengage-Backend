class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.references :team,           null: false, foreign_key: true

      t.string :name,                null: false
      t.string :address,             null: false
      t.string :time,                null: false
      t.string :day,                 null: false
      t.integer :max_players,        null: false
      t.timestamps
    end
  end
end
