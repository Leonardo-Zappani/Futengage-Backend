class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :team,                 null: false, foreign_key: true
      t.references :place,                null: false, foreign_key: true
      t.references :owner,                null: false, foreign_key: { to_table: :users }

      t.string :team_one_name,             null: false
      t.string :team_two_name,             null: false
      t.string :team_one_score,            null: false
      t.string :team_two_score,            null: false
      
      t.datetime :scheduled_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
