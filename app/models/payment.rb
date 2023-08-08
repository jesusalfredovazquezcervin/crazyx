class Payment < ApplicationRecord
  PAYMENT_TYPE= %w[Credit Debit Cash Transfer CoDi] #Status
  belongs_to :event
  belongs_to :player
end
