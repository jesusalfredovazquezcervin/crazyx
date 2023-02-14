class VerificationCode < ApplicationRecord
    belongs_to :player
    attribute :used, default: false
    before_save :generate_verification_code, if: :code_null
    
    private
      def code_null
        puts "--------- in code_null.-----------------"
        return self.code.nil?
      end

      def generate_verification_code
        puts "------- entering to generate_verification_code--------"
        #Returns a verification code to destroy a enrolled player. (Whe the player himself try to un enroll from an event.)
        code = SecureRandom.random_number(1000..9999)        
        exist = true
        player = Player.find(self.player_id)
        while exist
            code = SecureRandom.random_number(1000..9999)
            #check if 1.- there is a former not used code (used=false)
            exist = VerificationCode.where(code: code, used: false, player: player).any?
            #so far if the code not exist then exit the while            
        end
        self.code = code        

        # If there are already generated codes then we destroy all
        puts "------in the update_existing_verification_code ------------"
        existing_codes = VerificationCode.where(player_id: self.player_id, used: false)
        existing_codes.each{|code|
            code.destroy!
        }


      end
      
      
    
    
end
