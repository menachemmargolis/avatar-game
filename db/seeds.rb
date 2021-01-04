User.destroy_all
Game.destroy_all
Character.destroy_all
Element.destroy_all
User.reset_pk_sequence
Game.reset_pk_sequence
Character.reset_pk_sequence
Element.reset_pk_sequence

# t.string :name
# t.string :skill_1
# t.string :skill_2
# t.string :skill_3
# t.string :skill_4


fire = Element.create(name: "Fire", skill_1: "FireBall", skill_2: "FireWall", skill_3: "BlazingKick", skill_4: "LightningBolt")
water = Element.create(name: "Water", skill_1: "waterWhip", skill_2: "IceWall", skill_3: "IceBarrage", skill_4: "BloodBending")
earth = Element.create(name: "Earth", skill_1: "RockThrowing", skill_2: "RockWall", skill_3: "LavaBending", skill_4: "MetalBending")
air = Element.create(name: "Air", skill_1: "AirSlash", skill_2: "AirBall", skill_3: "Redirection", skill_4: "Flight")

# t.string :name
# t.integer :element_id
# t.string :nation

# aang 
# zuko 
# katara
# azula
# iroh
# ozai
# bumi
# toph
# kora
# tenzin
# amon
# lin 
# jinora



madiwa = User.create(name: "madiwa")
menachem = User.create(name: "menachem")



puts "📼 📼 📼 📼 SEEDED 📼 📼 📼 📼 "