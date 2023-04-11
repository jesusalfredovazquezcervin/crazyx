class MatchPlayersController < ApplicationController
  before_action :set_match_player, only: %i[ show edit destroy edit update ] 
  # GET /match_players or /match_players.json
  def index
    @match_players = MatchPlayer.where(event_id: params[:id])
    @event = Event.find(params[:id])
  end

  # GET /match_players/1 or /match_players/1.json
  def show
    #render layout: "empty"
  end

  # GET /match_players/new
  def new
    @event = Event.find(params[:id])    
    @match_player = MatchPlayer.new
    #render layout: "empty"
  end

  # POST /match_players or /match_players.json
  def create
    #Validations
    mp = MatchPlayer.create(match_player_params)
    respond_to do |format|      
      if !mp.errors.messages.any?      
        mp.setStatus
        mp.save!
        format.html { redirect_to match_player_url(mp), notice: "You have joined succesfully to the event"}
        format.json { render :show, status: :created, location: @match_player }
      else
        event_id =  match_player_params[:event_id]
        #format.html { render :new, status: :unprocessable_entity}
        #flash[:notice] = result_saving.errors.full_messages.to_sentence
        #flash[:notice]="some error"        
        format.html {redirect_to new_match_player_url(event_id), notice: mp.errors}
        format.json { render json: @match_player.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /match_players/1/edit
    def edit
    #Debo validar la existencia de algun codigo previo. 
    #Eliminar todos los existentes y crear uno nuevo y despues enviar este codigo a la pantalla de editar    
    @match_player.player.VerificationCodes.where(used: false).destroy_all
    @verification_code = VerificationCode.create(code: SecureRandom.random_number(1000..9999), player_id: @match_player.player_id, event_id: @match_player.event_id)
    
    #We must send the verification code to the cellphone
    message = "This is your verification code: " << @verification_code.code.to_s
    sms = Message.new(number: @match_player.player.cellphone, body: message, action: "edit_verification_code", controller: "MatchPlayersController")
    result = sms.send_sms
    sms.error = result.error_message
    sms.save!

    flash.now[:notice] = "We've send you another code, please check your messages!'" if params[:resend] == "true"
    #logger.debug "------------- Hello there resend = True #{params[:resend]}    ------------"
    render(layout: "empty")
    
  end
  
    # PATCH/PUT /match_players/1 or /verification_codes/1.json
  def update
      @verification_code = VerificationCode.find(params[:match_player][:verification_id])
      if params[:match_player][:code].to_i == @verification_code.code    
        #se actualiza el codigo a usado=true
        @verification_code.used = true
        
        #se elimina al player del evento
        @match_player.destroy
        respond_to do |format|    
          if @verification_code.save
            #format.html { redirect_to verification_code_url(@verification_code), notice: "Verification code was successfully updated." }
            format.html { redirect_to new_match_player_path(@match_player.event_id), notice: "The player has been successfully withdrawn from the event." }
            #format.json { render :show, status: :ok, location: @verification_code }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @verification_code.errors, status: :unprocessable_entity }
            format.turbo_stream { render :form_update, status: :unprocessable_entity }        
          end
        end  
      else      
        respond_to do |format|
          flash.now[:notice] = "The verification code does not match or is no longer valid. Try again."
          format.html { render :edit, status: :unprocessable_entity, notice: "The verification code does not match or is no longer valid. Try again." }
          format.json { render json: @verification_code.errors, status: :unprocessable_entity }
          format.turbo_stream { render :form_update, status: :unprocessable_entity }  
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
      params.require(:match_player).permit(:event_id, :player_id, :status, :code)
    end
end
