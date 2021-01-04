class Game < ActiveRecord::Base
   belongs_to :user 
   belongs_to :character

def game_fight
   character_id < character_id2
end
#  binding.pry
end