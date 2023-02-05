class AddPlayerToEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :player, null: true, foreign_key: true
  end
end
