class PaymentsController < ApplicationController
  before_action :authenticate_user!, except: %i[ new create ]
  before_action :check_user_role, except: %i[ new create dashboard]
  before_action :set_payment, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index    
    @event = Event.find(params[:id])
    @payments = @event.payments
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
    @event = @payment.event
  end

  # POST /payments or /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully created." }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|      
      #we calculate my retainer
      retainer = params[:payment][:cost].to_i * 0.05
      params[:payment][:retainer] = retainer.to_s

      #we modify the date to a full datetime
      tmp_date = DateTime.strptime(params[:payment][:payment_date], '%Y-%m-%d')      
      final_date = DateTime.new(tmp_date.year, tmp_date.month, tmp_date.day, DateTime.now.hour, DateTime.now.min, DateTime.now.sec)
      params[:payment][:payment_date] = final_date.strftime("%Y-%m-%d %H:%M:%S")

      if @payment.update(payment_params)
        format.html { redirect_to event_payments_path(@payment.event.id), notice: "Payment was successfully updated." }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:event_id, :player_id, :cost, :retainer, :payment_type, :reference, :comments, :payment_date)
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
