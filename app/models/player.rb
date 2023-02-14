class Player < ApplicationRecord
    CATEGORY= %w[1 2 3 4 5] 
    has_many :events
    has_many :MatchPlayers
    has_many :VerificationCodes
    validates :cellphone, uniqueness: true

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

    def generalRank
        #return the rank over all the players
        rank=0
        players = Player.all
        players.each{ |p|
            if p.totalScore.nil?
                p.updateTotalScore            
            end
        }

        rankings=Player.pluck(:id, :totalScore)
        
        rankings.sort_by{|totalScore|
            rank+=1
            break if totalScore[0]== self.id
        }
        #puts "The rank for the player id -> #{self.id} is -> #{rank}"
        return rank
    end

    def categoryRank
        #return the rank over your category
        rank=0
        category = self.category
        players = Player.all.where(category: category)
        players.each{ |p|
            if p.totalScore.nil?
                p.updateTotalScore
            end
        }

        players = Player.all.where(category: category)
        rankings=players.pluck(:id, :totalScore)
        
        rankings.sort_by{|totalScore|
            rank+=1
            break if totalScore[0]== self.id
        }
        #puts "The rank for the player id -> #{self.id} is -> #{rank}"
        return rank
    end
    def wonMatches 
        #return the number of won matches
        return 3
    end
    def lostMatches 
        #return the number of lost matches
        return 5
    end
    def winRatio 
        #returns the win ratio
        ratio = 0.0
        player = Player.find(self.id)
        lost = player.lostMatches.to_f
        won = player.wonMatches.to_f
        
        if lost == 0 && won == 0
            return 0
        elsif lost == 0 && won > 0
            return 1
        else            
            ratio = won/lost
            return ratio * 100
        end 
    end
end
