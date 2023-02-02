class MatchPlayersController < ApplicationController
  before_action :set_match_player, only: %i[ show edit update destroy ]

  # GET /match_players or /match_players.json
  def index
    @match_players = MatchPlayer.all
  end

  # GET /match_players/1 or /match_players/1.json
  def show
  end

  # GET /match_players/new
  def new
    @match_player = MatchPlayer.new
  end

  # GET /match_players/1/edit
  def edit
  end

  # POST /match_players or /match_players.json
  def create
    @match_player = MatchPlayer.new(match_player_params)

    respond_to do |format|
      if @match_player.save
        format.html { redirect_to match_player_url(@match_player), notice: "Match player was successfully created." }
        format.json { render :show, status: :created, location: @match_player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @match_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /match_players/1 or /match_players/1.json
  def update
    respond_to do |format|
      if @match_player.update(match_player_params)
        format.html { redirect_to match_player_url(@match_player), notice: "Match player was successfully updated." }
        format.json { render :show, status: :ok, location: @match_player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @match_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /match_players/1 or /match_players/1.json
  def destroy
    @match_player.destroy

    respond_to do |format|
      format.html { redirect_to match_players_url, notice: "Match player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match_player
      @match_player = MatchPlayer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def match_player_params
      params.require(:match_player).permit(:event_id, :player_id, :status)
    end
end
