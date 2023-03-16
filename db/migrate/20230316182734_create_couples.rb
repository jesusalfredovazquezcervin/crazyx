class CreateCouples < ActiveRecord::Migration[7.0]
  def change
    create_table :couples do |t|
      t.references :event, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :mate_id, null: false
      t.integer :number

      t.timestamps
    end
    add_foreign_key :couples, :players, column: :mate_id
  end
end
