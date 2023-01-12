class CreateFutengages < ActiveRecord::Migration[7.0]
  def change
    create_table :futengages do |t|
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.datetime :confirmed_at
      t.datetime :day, null: false 
      t.string :time, null: false, default: "20h"
      t.string :place, null: false, default: "Clubinho"
      t.string :team_name_1, null: false, default: "Time 1"
      t.string :team_name_2, null: false, default: "Time 2"
      t.bigint :team_score_1, null: false, default: 0
      t.bigint :team_score_2, null: false, default: 0
      t.references :user, foreign_key: true
    end
  end
end
