class Message < ApplicationRecord
    
    
    def send_sms
        #This method will send an sms message
        number = "52" << self.number # Uncomment this line to work in production
        #number = "524461327380" #comment this line to work in production        
        #number = "524422859104" #comment this line to work in production        
        account_sid =  ENV['TWILIO_ACCOUNT_SID']
        auth_token =  ENV['TWILIO_AUTH_TOKEN']
        messaging_service_sid= ENV['TWILIO_MSG_SERVICE_ID']
        @client = Twilio::REST::Client.new(account_sid, auth_token) 
        sms = @client.messages.create(body: self.body,  messaging_service_sid: messaging_service_sid, to: number) 
        logger.info("Message has been send: '#{self.body} ' ")
        return sms

    end
end