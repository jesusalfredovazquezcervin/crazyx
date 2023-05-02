class Event < ApplicationRecord
    include Rails.application.routes.url_helpers
    STATUS= %w[Open Closed] #Status
    belongs_to :player, optional: true
    attribute :status, :string, default: 'Open'
    has_many :match_player
    has_many :matches
    has_many :score
    has_many :verification_codes
    has_many :results
    has_many :couples
    attribute :message_sent, :boolean, default: false
    def getPlayersPoints
        # Obtain the sumatory of points for all the players for the event {player, total_points} {1=>9, 2=>20, 3=>15, 4=>14, 5=>1, 6=>1}
        id = self.id
        # We grab all the players for the event
        players = MatchPlayer.where(event_id: id, status: "OnBoard")
        points_per_player = {}
        players.each{|player|
            points_per_event = Match.where(event_id: id, playerOne: player.player_id).where.not(pointsOne: nil).collect{|p| p.pointsOne}.sum
            points_per_event += Match.where(event_id: id, playerTwo: player.player_id).where.not(pointsTwo: nil).collect{|p| p.pointsTwo}.sum
            points_per_event += Match.where(event_id: id, playerThree: player.player_id).where.not(pointsThree: nil).collect{|p| p.pointsThree}.sum
            points_per_event += Match.where(event_id: id, playerFour: player.player_id).where.not(pointsFour: nil).collect{|p| p.pointsFour}.sum
            points_per_player[player.player_id] = points_per_event            
        }
        return points_per_player
    end 
    
    def getWinner
        # Get the winner [player, points] for the event
        points_per_player= self.getPlayersPoints.sort_by{|k, v| -v}
        #winner = points_per_player.sort_by{|key, value| value}.last
        
        #here we get noy only one posible winner but n winners
        max=points_per_player.max_by{|key, value| value }
        winner = points_per_player.select{|k, v| v == max[1]}

        points_per_player.each.with_index(1){|point, position|
            if point[1] == max[1]
                #update the position in the score model for the event-player
                score = Score.where(event_id: self.id, player_id: point[0]).first
                score.position = 1                
            else
                score = Score.where(event_id: self.id, player_id: point[0]).first
                score.position = position
            end
            score.save            
        }
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

    def create_round_of_matches
        if self.mixed
            # Create a set of matches per round depending on the total players for the event (event.people)
            # Example: People = 12. Ergo we need 3 matches (each match 4 different person) per round
            # So this method will generate 3 matches each 4 different person.
            result = false
            event = Event.find(self.id)
            #We create the round robbin
            rounds = round_robin
            #puts "The max num of round is -> #{rounds.size}"
            #Find which round goes?
            num_round=get_num_rounds 
            
            #round_to_create = [[7, 1], [4, 2], [14, 5], [15, 16], [18, 6], [17, 19]]
            #round = [[P1, P2],[P3, P4],      [P1, P2], [P3, P4],       [P1, P2], [P3, P4]]
            if num_round >= rounds.size
                position = num_round%rounds.size
            else
                position = num_round
            end

            round_to_create = rounds[position]
            len = round_to_create.size - 1
            
            #  loop principal que barre todos los elementos de una ronda
            playerOne, playerTwo, playerThree, playerFour = 0
            (0..len).each.with_index{|p, i|    

                if i.even?
                    #puts "Asignation to match.playerOne with -----> #{round_to_create[p][0]}"
                    #puts "Asignation to match.playerTwo with -----> #{round_to_create[p][1]}"
                    playerOne = round_to_create[p][0]
                    playerTwo = round_to_create[p][1]
                    puts "[ #{playerOne}, #{playerTwo} ]"
                    puts ""
                end
                
                if i.odd?
                    #entonces guardamos match
                    #puts "Asignation to match.playerThree with -----> #{round_to_create[p][0]}"
                    #puts "Asignation to match.playerFour with -----> #{round_to_create[p][1]}"
                    playerThree = round_to_create[p][0]
                    playerFour = round_to_create[p][1]
                    puts "[ #{playerThree}, #{playerFour} ]"
                    Match.create(event_id: self.id, playerOne: playerOne, playerTwo: playerTwo, playerThree: playerThree, playerFour: playerFour, round: num_round+1 )
                    
                    #Clear the players
                    playerOne, playerTwo, playerThree, playerFour = 0                
                end
            }
            #puts "Round number #{num_round+1} of matches created ---> #{round_to_create}"
            result = true if get_num_rounds > num_round
        else
            #Fixed couples
            teams = round_robin
            i=0
            
            teams.each.with_index(get_num_rounds+1){|matches, round| 
                #puts "ronda #{round} ----> match #{matches}"
                #ronda n ----> match [[1, 2], [3, 4]]
                #ronda n ----> match [[pareja1 , pareja2], [pareja3, pareja4]]
                matches.each{|match|
                    puts "single match -->#{match}"
                    couple_one = Couple.find(match.first)
                    couple_two = Couple.find(match.second)
                    Match.create(event_id: self.id, round: round, 
                    playerOne: couple_one.player.id, 
                    playerTwo: couple_one.mate.id, 
                    playerThree: couple_two.player.id, 
                    playerFour: couple_two.mate.id )
                }
                i+=1
                
                result = true if i == teams.size                
            }

        end
        return result
    end
    
    
    
    require "round_robin_tournament"
    def round_robin 
        if self.mixed
            match_players = MatchPlayer.where(event_id: self.id, status: "OnBoard")
            players = match_players.collect{|mp| mp.player_id}
            #NOTE: players is a collection of number sorted always in the same way
            # If you want to add another pint of randomness, then you have to pass to the RoundRobinTournament method the player list shuffled
            teams = RoundRobinTournament.schedule(players)
            # Print for each day, each team
            teams.each_with_index do |day, index|
                day_teams = day.map { |team| "(#{team.first}, #{team.last})" }.join(", ")
                #puts "Day #{index + 1}: #{day_teams}"
            end            
        else
            couples = Couple.where(event_id: self.id).collect{|c| c.id}
            couples.shuffle!
            teams = RoundRobinTournament.schedule(couples)
            
        end
        teams.each{|m| m.shuffle!}
        #puts teams
        return teams
    end
    def get_num_rounds
        #returns the number of total rounds created for the event
        num_round=0 
        rounds_created=Match.where(event: self.id).select("round").group("round")
        if rounds_created.any?
            num_round = rounds_created.sort_by{|m| m.round}.last.round     
        end
        return num_round
    end
    def target 
        #returns the datetime target 
        return DateTime.new(self.eventDate.year, self.eventDate.month, self.eventDate.day, self.timeIni.try(:hour).nil? ? 0:self.timeIni.hour, self.timeIni.try(:min).nil? ? 0:self.timeIni.min, self.timeIni.try(:sec).nil? ? 0:self.timeIni.sec, Rational(-6, 24))
    end    
end
