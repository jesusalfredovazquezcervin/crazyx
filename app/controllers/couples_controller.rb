class CouplesController < ApplicationController
  before_action :set_couple, only: %i[ show edit update destroy ]

  # GET /couples or /couples.json
  def index
    @couples = Couple.where(event_id: params[:id])
  end

  # GET /couples/1 or /couples/1.json
  def show
  end

  # GET /couples/new
  def new
    @couple = Couple.new
    @couple.event_id = params[:id]
    @players_to_mate = Player.ready_to_mate(params[:id])
  end

  # GET /couples/1/edit
  def edit
  end

  # POST /couples or /couples.json
  def create
    @couple = Couple.new(couple_params)
  
    respond_to do |format|
      if @couple.save
        format.html { redirect_to event_couples_url(@couple.event_id), notice: "Couple was successfully created." }
        format.json { render :show, status: :created, location: @couple }
      else
        @players_to_mate = Player.ready_to_mate(params[:event_id])
        format.html { render :new, locals: {couple: @couple}, status: :unprocessable_entity }
        format.json { render json: @couple.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /couples/1 or /couples/1.json
  def update
    respond_to do |format|
      if @couple.update(couple_params)
        format.html { redirect_to couple_url(@couple), notice: "Couple was successfully updated." }
        format.json { render :show, status: :ok, location: @couple }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @couple.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /couples/1 or /couples/1.json
  def destroy
    @couple.destroy

    respond_to do |format|
      format.html { redirect_to couples_url, notice: "Couple was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couple
      @couple = Couple.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def couple_params
      params.require(:couple).permit(:player_id, :mate_id, :event_id)
    end
end
