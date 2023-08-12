class AddActiveToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :active, :boolean, default: true
  end
end
