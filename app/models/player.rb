class Player < ApplicationRecord
    CATEGORY= %w[1st 2nd 3rd 4th 5th] 
    has_many :events

    def updateTotalScore 
        #Compute all the gainned points and update the totalScore field
        total_score = Score.where(player_id: self.id).collect{|score| score.points }.sum
        self.totalScore = total_score
        self.save!
    end
end
