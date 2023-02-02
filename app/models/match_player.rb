class MatchPlayer < ApplicationRecord
  #This model keeps the players who are onboard for one particular event.
  belongs_to :event
  belongs_to :player
  STATUS= %w[OnBoard OnHold Canceled] #Status
end
