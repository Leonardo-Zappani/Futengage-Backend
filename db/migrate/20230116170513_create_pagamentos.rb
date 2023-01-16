class CreatePagamentos < ActiveRecord::Migration[7.0]
  def change
    create_table :pagamentos do |t|

      t.timestamps
    end
  end
end
