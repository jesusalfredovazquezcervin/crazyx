class AddRequestAndConfirmationToMatchPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :match_players, :request, :datetime
    add_column :match_players, :confirmed, :boolean
    add_column :match_players, :confirmation_date, :datetime
  end
end
