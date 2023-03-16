class Couple < ApplicationRecord
  belongs_to :event
  belongs_to :player
  belongs_to :mate, class_name: "Player"
  #has_many :datosgenerales, :through => :agenda_accounts
end
