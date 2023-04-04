class AddMessageSentToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :message_sent, :boolean
  end
end
