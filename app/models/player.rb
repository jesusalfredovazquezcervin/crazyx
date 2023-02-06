class Player < ApplicationRecord
    CATEGORY= %w[1st 2nd 3rd 4th 5th] 
    has_many :events
    has_many :MatchPlayers
    def updateTotalScore 
        #Compute all the gainned points and update the totalScore field
        total_score = Score.where(player_id: self.id).collect{|score| score.points }.sum
        self.totalScore = total_score
        self.save!
    end

    def age 
        #return the age of the player
        return ((Time.zone.now - self.birthDate.to_time) / 1.year.seconds).floor
    end
    
    def eventsPlayed 
        return MatchPlayer.where(player_id: self.id).count
    end
    
    def average 
        # return the mean points per event
        average = 0
        scores_p2 = Score.where(player_id: self.id)
        if !scores_p2.empty?
            point_scores_p2=scores_p2.collect{|s| s.points}
            average = (point_scores_p2.reduce(:+).to_f / point_scores_p2.size).to_i
        end
        return average
    end

    def rank
        rank=0
        players = Player.all
        players.each{ |p|
            p.updateTotalScore            
        }

        rankings=Player.pluck(:id, :totalScore)
        
        rankings.sort_by{|totalScore|
            rank+=1
            break if totalScore[0]== self.id
        }
        #puts "The rank for the player id -> #{self.id} is -> #{rank}"
        return rank
    end

    
end
