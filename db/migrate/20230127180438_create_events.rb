class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.date :eventDate
      t.integer :people
      t.string :status
      t.integer :winner

      t.timestamps
    end
  end
end
