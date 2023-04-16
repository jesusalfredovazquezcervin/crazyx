class Message < ApplicationRecord
    
    
    def send_sms
        #This method will send an sms message
        number = "52" << self.number # Uncomment this line to work in production        
        #number = "524461327380" #comment this line to work in production        
        account_sid = <%= Rails.application.credentials.dig(:twilio, :account_sid) %>
        auth_token = <%= Rails.application.credentials.dig(:twilio, :auth_token) %>
        messaging_service_sid= <%= Rails.application.credentials.dig(:twilio, :msg_service_id) %>
        @client = Twilio::REST::Client.new(account_sid, auth_token) 
        sms = @client.messages.create(body: self.body,  messaging_service_sid: messaging_service_sid, to: number) 
        return sms

    end
end
