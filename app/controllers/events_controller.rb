class EventsController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!, except: %i[ dashboard show_closed_event confirmed]
  before_action :check_user_role, except: %i[ dashboard show_closed_event confirmed]
  before_action :set_event, only: %i[ show edit update destroy update_status show_closed_event send_sms_request_confirmation]
  

  # GET /events or /events.json
  def index
    @events = Event.all.reverse
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # PATCH/PUT /events/1/close or /events/1/close.json
  def update_status 
    respond_to do |format|
      @event.status = "Closed"
      @event.getWinner      
      if @event.save
        #we create the payments records
        create_payments
        #we send the sms to inform to the winners
        send_sms_to_winner if !@event.message_sent

        format.html { redirect_to show_closed_event_path(@event), notice: "Event was succesfully closed!"  }      
        format.json { render :close, status: :ok, location: @event }
      else
        format.html { redirect_to players_enrolled_url(@event), status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

    
  end
  def create_payments
    #if Business.exists?(user_id: current_user.id)
    @event.match_player.each{|mp|
      if !Payment.exists?(event_id: @event.id, player_id: mp.player.id )
        Payment.create(event_id: @event.id, player_id: mp.player.id)
      end
    }    


  end
  def show_closed_event
    @scores = @event.score.where("points > 0").sort_by{|s| s.points}.reverse
  end  

  def send_sms_to_winner
    url = show_closed_event_url(@event.id)        
    @event.score.where(position: 1).each{|winner|
      message = "FEMAC PADEL RETAS - Congratulations #{winner.player.name.titleize}, You won the event '#{@event.name}'. See the results here:  #{url}"
      sms = Message.new(number: winner.player.cellphone, body: message, action: "send_sms_to_winner", controller: "events_controller.rb")
      result = sms.send_sms
      sms.error = result.error_message
      sms.save!
      if result.error_message.nil?
        @event.message_sent=true
        @event.save!
      end
    }
  end
  def send_sms_request_confirmation 
    sms_error = nil
    #url = "http://www.google.com"    
    #This method send sms requesting confirmation to an event for all enrolled players
    @event.match_player.where(confirmed: nil).or(@event.match_player.where(confirmed: false)).each{|mp|
      #Send sms
      url = event_confirmed_url(@event.id, mp.player_id)
      message = "FEMAC PADEL - Confirmation: #{mp.player.name.titleize}, please confirm your asistence to the event for #{@event.target.strftime("%d/%m/%Y %H:%M")}. Click here to confirm:  #{url}"
      sms = Message.new(number: mp.player.cellphone, body: message, action: "send_request_confirmation_sms", controller: "events_controller.rb")
      result = sms.send_sms
      sms.error = result.error_message
      sms.save!
      sms_error = result.error_message if !result.error_message.nil?
      
      #Update the fields for the confirmation request message
      mp.request = DateTime.now
      mp.confirmed = false
      mp.save
    }
    respond_to do |format|
      if sms_error.nil?
        format.html { redirect_to events_url, notice: "The sms sending process was successful!" }
        format.json { head :no_content }
      else
        format.html { redirect_to events_url, alert: "There were errors during the sms sending process!"  }      
        format.json { render json: sms_error, status: :unprocessable_entity }
      end
    end          
  end
  def confirmed
    #This method save the player confirmation
    @event = Event.find(params[:event_id].to_i)
    @player = Player.find(params[:player_id].to_i)
    
    if @event.status == "Closed"
      flash[:notice]= "The event is already closed!"
    else
      error=false
      mp = MatchPlayer.where(event_id: params[:event_id].to_i, player_id: params[:player_id].to_i).first
      #Update the fields for the confirmed request
      mp.confirmation_date = DateTime.now
      mp.confirmed = true      
      if mp.save
        flash[:notice]= "Player updated succesfully!"
      else
        flash[:notice]= "Player NOT updated succesfully!"
      end
    end

    
  end

  
  def dashboard
    #here we have the next seven days events
    dateIni = Date.today
    #@events = Event.where(public: true, status: "Open", eventDate: dateIni..dateIni+7).collect{|e| e}.group_by{|e| e.eventDate}.sort_by{|ebd| ebd[0]}
    @events = Event.where(public: true, status: "Open", eventDate: dateIni..dateIni+7).select{|e| e if e.target >DateTime.now }.sort_by{|e| e.target }.group_by{|e| e.eventDate}
    #@total_events = Event.where(status: "Open", eventDate: dateIni..dateIni+7).collect{|e| e}.count
    @total_events = Event.where(status: "Open", eventDate: dateIni..dateIni+7).select{|e| e if e.target > DateTime.now}.count
    #@next_event = Event.where(status: "Open", eventDate: dateIni..dateIni+7).collect{|e| e}.sort_by{|e| [e.eventDate, e.timeIni]}.first
    @next_event = Event.where(status: "Open", eventDate: dateIni..dateIni+7).select{|e| e if  e.target > DateTime.now}.sort_by{|e| e.target }.first
    @round = 1
  end
  def event_validation 
    logger.info "---------------Entramos en el metodo 'event_validation'----------"
    logger.info "---------------Estos son los parametros-> #{params}"
    @event_exist = false
    if !(params[:date] == "") && !(params[:start] == "") && !(params[:category] == "")
      @event = Event.where(eventDate: Date.strptime(params[:date],"%Y-%m-%d"), timeIni: Time.parse(params[:start]), level: params[:category].to_i, status: "Open").first      
      @event_exist = true if !@event.nil?      
    end
    logger.info "The event found is-> #{@event.id if !@event.nil?}"
    logger.info "---------------¿Existe el evento?: #{@event_exist}----------"
    if @event_exist      
      respond_to do |format|
        format.turbo_stream { render :event_validation }
      end  
    end
    
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :eventDate, :people, :status, :winner, :timeIni, :timeEnd, :mixed, :level, :public)
    end
    
    def check_user_role    
      case current_user.role        
        when "Player"
          respond_to do |format|
            format.html { redirect_to dashboard_player_path(current_user.player_id), notice: "...redirected to the dashboard page!"  }
            format.json { head :no_content }
          end
      end
    end
    
end
