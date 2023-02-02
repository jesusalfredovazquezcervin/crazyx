class Player < ApplicationRecord
    CATEGORY= %w[1st 2nd 3rd 4th 5th] 
    has_many :events
end
