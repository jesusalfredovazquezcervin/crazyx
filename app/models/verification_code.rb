class VerificationCode < ApplicationRecord
  belongs_to :player
  belongs_to :event
  attribute :used, default: false  
end