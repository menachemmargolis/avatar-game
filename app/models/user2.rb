class User2 < ActiveRecord::Base
    has_many :games 
    has_many :characters, through: :games

end