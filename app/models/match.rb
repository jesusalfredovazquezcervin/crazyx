class Match < ApplicationRecord
  belongs_to :event


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
end
