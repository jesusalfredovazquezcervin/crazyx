class CreateMatchPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :match_players do |t|
      t.references :event, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
