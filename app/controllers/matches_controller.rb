class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_role
  before_action :set_match, only: %i[ show edit update ]

  # GET /matches or /matches.json
  def index
    @event = Event.find(params[:id])
    #@matches = @event.matches
    @scores = @event.score.where("points > 0").sort_by{|s| s.points}.reverse
    if params[:round].nil?
      @round = 1
    else
      @round = params[:round]
    end
    flash[:alert]= "Not enough couples" if !@event.mixed? && !(@event.couples.count == @event.people/2)
  end
  def player_matches
    @event = Event.find(params[:event_id])
    @player = Player.find(params[:player_id])
    @matches = @event.matches.where(playerOne: params[:player_id]).or(@event.matches.where(playerTwo: params[:player_id])).or(@event.matches.where(playerThree: params[:player_id])).or(@event.matches.where(playerFour: params[:player_id]))    
  end


  # GET /matches/1 or /matches/1.json
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
    @round = params[:round]
  end

  # POST /matches or /matches.json
  def create
    @match = Match.new(match_params)
    audit! :create_match, @match, payload: match_params
    respond_to do |format|
      if @match.save
        format.html { redirect_to match_url(@match), notice: "Match was successfully created." }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def update    
    params[:match][:pointsTwo]= params[:match][:pointsOne]
    params[:match][:pointsFour]= params[:match][:pointsThree]
    @round = params[:match][:round]
    respond_to do |format|
      if @match.update(match_params)
        audit! :update_match, @match, payload: match_params
        format.html { redirect_to event_matches_url(@match.event_id, @round), notice: "Match was successfully updated." }
        format.json { render :show, status: :ok, location: @match }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1 or /matches/1.json
  def destroy    
    #logger.debug "------------------------------------------"
    #logger.debug "this are the params #{params}"
    Match.where(event_id: params[:event_id], round: params[:round]).destroy_all
    audit! :delete_match, nil, payload: {event_id: params[:event_id], round: params[:round]}
    respond_to do |format|
      format.html { redirect_to event_matches_url(params[:event_id]), notice: "Round #{params[:round]} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /matches/1 or /matches/1.json
  def create_round_of_matches
    #Calls to the create_round_of_matches event over the event and then returns to rounds of the event
    @event = Event.find(params[:event_id])
    respond_to do |format|
      if @event.create_round_of_matches
        AuditLog.audit!(:create_round_of_matches, @event, payload: @event.attributes)
        format.html { redirect_to event_matches_url(params[:event_id]), notice: "Round created successfully!" }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { redirect_to event_matches_url(params[:event_id]), notice: "An error ocurred during the round creation!" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def match_params
      params.require(:match).permit(:event_id, :playerOne, :pointsOne, :playerTwo, :pointsTwo, :playerThree, :pointsThree, :playerFour, :pointsFour, :round)
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
