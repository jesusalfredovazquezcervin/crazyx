class Message < ApplicationRecord
    
    
    def send_sms
        #This method will send an sms message
        #number = "52" << self.number # Uncomment this line to work in production        
        number = "524461327380" #comment this line to work in production
        account_sid = 'ACc08ca94532b4f7c849560154f0269a40' 
        auth_token = '854bf1c3814388e565f14729b0681e9e' 
        messaging_service_sid= 'MGbb8cfa4182eb40f0613808722637f813'
        @client = Twilio::REST::Client.new(account_sid, auth_token) 
        sms = @client.messages.create(body: self.body,  messaging_service_sid: messaging_service_sid, to: number) 
        return sms

    end
end
