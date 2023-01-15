class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :owner,           null: false, foreign_key: { to_table: :users }

      t.string :group_name,          null: false
      t.string :team_one_name,       null: false, default: "Time 1"
      t.string :team_two_name,       null: false, default: "Time 2"

      t.timestamps
    end
  end
end
