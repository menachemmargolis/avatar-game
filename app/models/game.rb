class Game < ActiveRecord::Base
   belongs_to :user
   belongs_to :character

   def to_s
      self.id
   end


end