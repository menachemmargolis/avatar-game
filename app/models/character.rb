class Character < ActiveRecord::Base
    has_many :games 
    has_many :users, through: :game
    has_many :elements
end