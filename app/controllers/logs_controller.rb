class LogsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_user_role
    before_action :set_log, only: %i[ show ]
    #logs GET    /                   audit_log/logs#index
    def index
        @logs = AuditLog::Log.all
    end


    def show        
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = AuditLog::Log.find(params[:id])
    end    

    # Only allow a list of trusted parameters through.
    #def log_params
    #  params.require(:event).permit(:name, :eventDate, :people, :status, :winner, :timeIni, :timeEnd, :mixed, :level, :public)
    #end
    
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