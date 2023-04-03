class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy update_status show_closed_event]

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
        format.html { redirect_to show_closed_event_path(@event), notice: "Event was succesfully closed!"  }      
        format.json { render :close, status: :ok, location: @event }
      else
        format.html { redirect_to players_enrolled_url(@event), status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

    
  end
  
  def show_closed_event
    @scores = @event.score.where("points > 0").sort_by{|s| s.points}.reverse
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
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :eventDate, :people, :status, :winner, :timeIni, :timeEnd, :mixed, :level, :public)
    end
end
