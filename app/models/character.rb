class Character < ActiveRecord::Base
    has_many :games 
    has_many :users, through: :game
    has_many :elements

    def to_s
        self.name
    end

    def self.all_names
        self.all.map{|character|{character.name => character.id}}
    end
    
end