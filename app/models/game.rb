class Game < ActiveRecord::Base
   belongs_to :user
   belongs_to :character

   # belongs_to :waterer, :class_name => "Person", :foreign_key => "person_id"
   # belongs_to :wateree, :class_name => "Plant", :foreign_key => "plant_id"

# def to_s
#    self.id
# end

# def self.all_id
#    self.all.map{|games|games}
# end
# def game_result_helper
#    Character.element_id
# end

# def game_result_helper2
#    Character.element_id
# end

# def self.game_result
#    self.game_result_helper.element_id > self.game_result_helper2.element_id
# end

end