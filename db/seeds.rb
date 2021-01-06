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

aang = Character.create(name: "Aang", element_id: air.id, nation: "Avatar")
zuko = Character.create(name: "Zuko", element_id: fire.id, nation: "Fire Nation")
katara = Character.create(name: "Katara", element_id: water.id, nation: "Water Tribe")
azula = Character.create(name: "Azula", element_id: fire.id, nation: "Fire Nation")
iroh = Character.create(name: "Iroh", element_id: fire.id, nation: "Fire Nation")
ozai = Character.create(name: "Ozai", element_id: fire.id, nation: "Fire Nation")
bumi = Character.create(name: "Bumi", element_id: earth.id, nation: "Earth Kingdom")
toph = Character.create(name: "Toph", element_id: earth.id, nation: "Earth Kingdom")
kora = Character.create(name: "Kora", element_id: water.id, nation: "Avatar")
tenzin = Character.create(name: "Tenzin", element_id: air.id, nation: "Air Nomad")
amon = Character.create(name: "Amon", element_id: water.id, nation: "Water Tribe")
lin = Character.create(name: "Lin", element_id: earth.id, nation: "Earth Kingdom") 
jinora = Character.create(name: "Jinora", element_id: air.id, nation: "Air Nomad")





# game1 = Game.create(user_id: madiwa.id, user2_id: menachem.id, character_id: toph.id, character_id2: iroh.id, result: false)
# game2 = Game.create(user_id: menachem.id, user2_id: madiwa.id, character_id: tenzin.id, character_id2: aang.id, result: false)
# game3 = Game.create(user_id: madiwa.id, user2_id: menachem.id, character_id: azula.id, character_id2: iroh.id, result: true)
puts "📼 📼 📼 📼 SEEDED 📼 📼 📼 📼 "