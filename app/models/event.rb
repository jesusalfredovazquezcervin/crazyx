class Event < ApplicationRecord
    STATUS= %w[Open Closed] #Status
    belongs_to :player, optional: true
    attribute :status, :string, default: 'Open'
    has_many :match_player

    
    def getPlayersPoints
        # Obtain the sumatory of points for all the players for the event {player, total_points} {1=>9, 2=>20, 3=>15, 4=>14, 5=>1, 6=>1}
        id = self.id
        # We grab all the players for the event
        players = MatchPlayer.where(event_id: id, status: "OnBoard")
        points_per_player = {}
        players.each{|player|
            points_per_event = Match.where(event_id: id, playerOne: player.player_id).collect{|p| p.pointsOne}.sum
            points_per_event += Match.where(event_id: id, playerTwo: player.player_id).collect{|p| p.pointsTwo}.sum
            points_per_event += Match.where(event_id: id, playerThree: player.player_id).collect{|p| p.pointsThree}.sum
            points_per_event += Match.where(event_id: id, playerFour: player.player_id).collect{|p| p.pointsFour}.sum
            points_per_player[player.player_id] = points_per_event            
        }
        return points_per_player
    end 
    
    def getWinner
        # Get the winner [player, points] for the event
        points_per_player= self.getPlayersPoints
        winner = points_per_player.sort_by{|key, value| value}.last
        return winner
    end
    
    def updateWinner
        #update the field player_id and winner in the event
        winner = self.getWinner
        self.player_id = winner[0]
        self.winner = winner[1]
        self.save!
    end
    
    def updateScore
        # Update the scores for all the players in the event
        scores = getPlayersPoints # returns {player, total_points}
        scores.each{|player, total_points|
            s=Score.where(event_id: self.id, player_id: player)
            if s.empty?
                Score.create(event_id: self.id, player_id: player, points: total_points)
            else
                s=s[0]
                s.points = total_points
                s.save!
            end
        }

    end
    def onlyLeft
        #return the number of places left for the event {ej: Event people max = 12, players onboard = 4, onlyLeft= 12-4 = 8}
        event = Event.find(self.id)
        #We get the onboard players
        obPlayers = MatchPlayer.where(event_id: event.id, status: "OnBoard").count
        return event.people - obPlayers
    end
end
