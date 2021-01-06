class User < ActiveRecord::Base
    has_many :games 
    has_many :characters, through: :games


end

# Choose a Character,
# Change elements of Character,
# Quit the Game
# Destroy account