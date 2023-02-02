class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :category
      t.boolean :leftHanded
      t.date :birthDate
      t.integer :eventScore
      t.integer :totalScore

      t.timestamps
    end
  end
end
