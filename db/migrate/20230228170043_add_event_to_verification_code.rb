class AddEventToVerificationCode < ActiveRecord::Migration[7.0]
  def change
    add_reference :verification_codes, :event, null: false, foreign_key: true
  end
end
