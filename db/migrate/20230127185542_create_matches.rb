class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :event, null: false, foreign_key: true
      t.integer :playerOne
      t.integer :pointsOne
      t.integer :playerTwo
      t.integer :pointsTwo
      t.integer :playerThree
      t.integer :pointsThree
      t.integer :playerFour
      t.integer :pointsFour

      t.timestamps
    end
  end
end
