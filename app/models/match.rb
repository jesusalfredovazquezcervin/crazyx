class Match < ApplicationRecord
  belongs_to :event
  after_save :save_score_four_players
  after_destroy :save_score_four_players
  def match_result
    #returns if the match is: {even(0) Team1(1) Team2(2)} Team 
    #Team 1.- PlayerOne|PlayerTwo Team 2.- PlayerThree|PlayerFour
    result = 0
    if !self.pointsOne.nil? && !self.pointsThree.nil?
      if self.pointsOne > self.pointsThree
        result = 1
      elsif self.pointsOne < self.pointsThree
        result = 2
      end
    else
      result = -1 # There is no points
    end
    
    return result
  end
  def update_score(player)
    #Updates the scores for the players of the event
    e = Event.find(self.event_id)
    points_player=0
    points_player = e.matches.where(playerOne: player.id).sum(:pointsOne)+ e.matches.where(playerTwo: player.id).sum(:pointsTwo) + e.matches.where(playerThree: player.id).sum(:pointsThree) + e.matches.where(playerFour: player.id).sum(:pointsFour)
    score_player = Score.where(event_id: self.event_id, player_id: player.id)
    if score_player.any?
      score = score_player.first
      score.points = points_player
      score.save!
    else
      Score.create(event_id: event.id, player_id: player.id, points: points_player)
    end
    player.updateTotalScore            
  end

  def save_score_four_players
    update_score(Player.find(self.playerOne))
    update_score(Player.find(self.playerTwo))
    update_score(Player.find(self.playerThree))
    update_score(Player.find(self.playerFour))
  end
end
