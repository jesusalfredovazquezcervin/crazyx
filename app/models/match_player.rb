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
    if (event.onlyLeft == 1) && (MatchPlayer.where(event_id: event.id, status: "OnHold").count >=1 )
      mp = MatchPlayer.where(event_id:event.id, status: "OnHold").sort_by{|mp| mp.created_at}.first
      
      # Player who change status
      @player = mp.player
      puts "-----------------------------------------------------------------------------------"
      puts "The player #{@player.id} - #{@player.name} has changed status from 'OnHold' to 'OnBoard's"
      puts "-----------------------------------------------------------------------------------"
      mp.status = 'OnBoard'
      send_sms_status_change if mp.save!
    end    
  end

  def send_sms_status_change
    event = Event.find(self.event_id)    
    message = "From Padel Crazy X - Hello #{@player.name.titleize}, You are now OnBoard! for the Padel event: #{event.name} on #{event.eventDate.strftime('%d/%m/%Y')} from #{event.timeIni.strftime('%H:%M')} to #{event.timeEnd.strftime('%H:%M')}"
    sms = Message.new(number: @player.cellphone, body: message, action: "send_sms_status_change", controller: "match_player.rb")
    result = sms.send_sms
    sms.error = result.error_message
    sms.save!    
  end

  #def addVerifiedCallerId
    #this method adds a new caller Id such as my girl mobile phone number 442 3279641
  #  account_sid = 'ACc08ca94532b4f7c849560154f0269a40'
  #  auth_token = '9dfec69d0c13fcfe9bb89748c7617421'
  #  @client = Twilio::REST::Client.new(account_sid, auth_token)
  #  validation_request = @client.validation_requests.create(friendly_name: 'My girl mobile number',phone_number: '+524423279641')
  #  puts validation_request.friendly_name
  #end

end

