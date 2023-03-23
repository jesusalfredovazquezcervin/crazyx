class Player < ApplicationRecord
    CATEGORY= %w[1 2 3 4 5] 
    has_many :events
    has_many :MatchPlayers
    has_many :VerificationCodes
    validates :cellphone, uniqueness: true
    attribute  :totalScore, default: 0
    attribute  :eventScore, default: 0
    has_one_attached :image
    has_many :results
    has_many :scores
    #scope :de_cliente, -> (cliente) { where("cliente_id = ?", cliente) }
    #scope :ready_to_mate, -> { from_event.where("price > 500") }
    def self.ready_to_mate(event_id)
        event = Event.find(event_id)
        enrolled = event.match_player.where(status: "OnBoard").collect{|mp| mp.player }
        couples = event.couples
        players_not_elegible = couples.collect{|c| c.mate} + couples.collect{|c| c.player}
        return  enrolled.select{|p| p if players_not_elegible.exclude?(p)}
    end

    def updateTotalScore 
        #Compute all the gainned points and update the totalScore field
        total_score = Score.where(player_id: self.id).sum(:points)#Score.where(player_id: self.id).collect{|score| score.points }.sum
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
    def won_lost_draw_matches(event_id = nil) 
        #return a dictionary with the total number of won|lost|tied matches

        won_lost_draw = {total: 0, won: 0, lost: 0, tied: 0}
        
        #We count the matches result whe the player is PlayerOne or Two
        if event_id.nil?
            matches = Match.where(playerOne: self.id).or(Match.where(playerTwo: self.id))
        else
            matches = Match.where(playerOne: self.id, event_id: event_id).or(Match.where(playerTwo: self.id, event_id: event_id))
        end
        
        matches.each{|m|
            if m.pointsOne == m.pointsThree
                won_lost_draw[:tied] = won_lost_draw[:tied] + 1
            elsif m.pointsOne > m.pointsThree
                won_lost_draw[:won] = won_lost_draw[:won] + 1
            elsif m.pointsOne < m.pointsThree
                won_lost_draw[:lost] = won_lost_draw[:lost] + 1
            end
        }

        #We count the matches result whe the player is PlayerThree or Four
        if event_id.nil?
            matches = Match.where(playerThree: self.id).or(Match.where(playerFour: self.id))
        else
            matches = Match.where(playerThree: self.id, event_id: event_id).or(Match.where(playerFour: self.id, event_id: event_id))
        end
        matches.each{|m|
            if m.pointsOne == m.pointsThree
                won_lost_draw[:tied] = won_lost_draw[:tied] + 1
            elsif m.pointsThree > m.pointsOne
                won_lost_draw[:won] = won_lost_draw[:won] +1 
            elsif m.pointsThree < m.pointsOne
                won_lost_draw[:lost] = won_lost_draw[:lost] + 1
            end
        }
        won_lost_draw[:total] = won_lost_draw[:tied] + won_lost_draw[:won] + won_lost_draw[:lost]


        return won_lost_draw
    end
    def next_event
        return MatchPlayer.where(player_id: self.id).collect{|mp| mp.event }.select{|e| e.status=="Open"}.sort_by{|e| e.updated_at }.first
    end
    def winRate(event_id = nil) 
        #returns the win ratio
        if event_id.nil?
            won_lost_draw_matches = self.won_lost_draw_matches
        else
            won_lost_draw_matches = self.won_lost_draw_matches(event_id)
        end

        
        ratio = 0.0
        player = Player.find(self.id)
        lost = player.won_lost_draw_matches[:lost].to_f
        won = player.won_lost_draw_matches[:won].to_f
        
        if lost == 0 && won == 0
            return 0
        elsif lost == 0 && won > 0
            return 1
        else            
            rate = won/won_lost_draw_matches[:total].to_f
            return rate * 100
        end 
    end
end
