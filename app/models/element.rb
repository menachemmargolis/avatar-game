class Element < ActiveRecord::Base
  belongs_to :character

  def self.all_skill
    self.all.map{|element|element.skill_1}
  end

end