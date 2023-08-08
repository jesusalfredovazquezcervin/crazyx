class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :event, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.decimal :cost, precision: 10, scale: 2
      t.decimal :retainer, precision: 10, scale: 2
      t.string :payment_type
      t.string :reference
      t.string :comments
      t.datetime :payment_date

      t.timestamps
    end
  end
end
