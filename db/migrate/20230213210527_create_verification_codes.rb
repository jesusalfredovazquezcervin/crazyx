class CreateVerificationCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :verification_codes do |t|
      t.integer :code
      t.boolean :used
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
