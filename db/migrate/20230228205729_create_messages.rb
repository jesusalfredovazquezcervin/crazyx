class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :number
      t.string :body
      t.string :error
      t.string :action
      t.string :controller

      t.timestamps
    end
  end
end
