class AddPositionToScore < ActiveRecord::Migration[7.0]
  def change
    add_column :scores, :position, :integer
  end
end
