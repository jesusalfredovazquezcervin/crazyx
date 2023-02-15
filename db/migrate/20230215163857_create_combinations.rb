class CreateCombinations < ActiveRecord::Migration[7.0]
  def change
    create_table :combinations do |t|
      t.string :combination
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
