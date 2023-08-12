class AddActiveToConfirmation < ActiveRecord::Migration[7.0]
  def change
    add_column :confirmations, :active, :boolean, default: true
  end
end
