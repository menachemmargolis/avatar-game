class Game < ActiveRecord::Base
   belongs_to :user
   belongs_to :character

   def to_s
      self.id
   end

   def self.all_id
      self.all.map{|games|games}
   end


end