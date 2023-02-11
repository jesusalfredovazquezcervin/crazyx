class MatchPlayer < ApplicationRecord
  #This model keeps the players who are onboard for one particular event.
  belongs_to :event
  belongs_to :player
  STATUS= %w[OnBoard OnHold Canceled] #Status
  validates :player, uniqueness: { scope: :event,
   message: "This player is already enroled on the event" }

  def setStatus 
    #Set the status to the MatchPlayer depending on the qty players who have been signed in into the event
    event = Event.find(self.event_id)
    #We get the onboard players
    obPlayers = MatchPlayer.where(event_id: event.id).select{|mp| mp.status== 'OnBoard'}.count
    if obPlayers < event.people
      self.status = 'OnBoard'
    elsif obPlayers >= event.people
      self.status = 'OnHold'
    end    
  end
end

