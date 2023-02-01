class CreateConfirmations < ActiveRecord::Migration[7.0]
  def change
    create_table :confirmations do |t|
      t.references :member,              null: false, foreign_key: true
      t.references :match,               null: false, foreign_key: true
      t.references :user,                null: false, foreign_key: true

      t.integer :position
      t.integer :team_number
      
      t.datetime :confirmed_at   
      t.boolean :confirmed,                null: false, default: false

      t.timestamps
    end
  end
end
