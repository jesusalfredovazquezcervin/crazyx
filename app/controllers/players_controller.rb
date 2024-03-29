class PlayersController < ApplicationController
  before_action :authenticate_user!, except: %i[ new create ]
  before_action :check_user_role, except: %i[ new create dashboard]
  before_action :set_player, only: %i[ show edit update destroy ]
  

  # GET /players or /players.json
  def index
    @players = Player.all.sort_by{|p| p.totalScore}.reverse
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
    @event = Event.find(params[:event_id]) if !params[:event_id].nil?
  end
  
  # GET /players/1/edit
  def edit    
  end
  
  
  # POST /players or /players.json
  def create
    @player = Player.new(player_params)
    @player.cellphone = @player.cellphone.gsub(/\s+/, "")
    respond_to do |format|
      if @player.save
        audit! :create_player, @player, payload: player_params
        if !params[:event_id].nil? #entonces enrolamos al player
          mp = MatchPlayer.create(event_id: params[:event_id].to_i, player_id: @player.id)          
          if !mp.errors.messages.any?
            mp.setStatus
            mp.save!
            format.html { redirect_to match_player_url(mp), notice: "You have joined succesfully to the event"}
          end
        end
        format.html { redirect_to player_url(@player), notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    clean_cellphone = params[:player][:cellphone].gsub(/\s+/, "")
    #player_params[:cellphone] = "11111"
    params[:player][:cellphone] = clean_cellphone
    #logger.debug "-------------params------> #{params[:player][:cellphone]}"
    respond_to do |format|
      if @player.update(player_params)
        audit! :update_player, @player, payload: player_params
        format.html { redirect_to player_url(@player), notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy
    audit! :delete_player, @player, payload: @player.attributes    
    respond_to do |format|
      format.html { redirect_to players_url, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def dashboard
    if current_user.role == "Player"
      @player = Player.find(current_user.player_id)
    else
      @player = Player.find(params[:player_id])
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :category, :leftHanded, :birthDate, :eventScore, :totalScore, :cellphone, :image, :event_id)
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
