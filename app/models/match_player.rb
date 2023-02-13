class MatchPlayer < ApplicationRecord
  #This model keeps the players who are onboard for one particular event.
  belongs_to :event
  belongs_to :player
  STATUS= %w[OnBoard OnHold Canceled] #Status
  validates :player, uniqueness: { scope: :event, message: "This player is already enroled on the event" }
  after_destroy :set_player_status 

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
  def set_player_status
    #update the status (to onboard) of the first onhold player of the event
    #Note: this method will only change the status if the player had OnBoard Status
    event = Event.find(self.event_id)
    puts "Changing player status NHOLD ------>   ONBOARD #{self.id}"
    
    if (event.onlyLeft == 1) && (MatchPlayer.where(event_id: event.id, status: "OnHold").count >=1 )
      mp = MatchPlayer.where(event_id:event.id, status: "OnHold").sort_by{|mp| mp.created_at}.first
      mp.status = 'OnBoard'
      mp.save!
    end
    



  end
end

