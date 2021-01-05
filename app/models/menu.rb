class Menu
    attr_reader :prompt
    attr_accessor :user

    def initialize
        @prompt = TTY::Prompt.new
    end

    def menu_choice
      prompt.select("welcome to avatar fightinh game, please choose an option") do |menu|
        menu.choice "log in", -> {log_in}
        menu.choice "sign up", -> {sign_up}
        menu.choice "exit", -> {exit}
      end
    end

    def sign_up
      name = prompt.ask("choose a username")
      while User.find_by(name: name)
        puts "that name is already taken"
        name = prompt.ask("choose another username")
      end
      self.user = User.create(name: name)
      puts "welcom #{user.name}"
      main_screen
    end

    def log_in
      name = prompt.ask("enter username")
      while !User.find_by(name: name)
        puts "user has been found"
        name = prompt.ask("please enter correct username")
      end
      self.user = User.find_by(name: name)
      puts "welcome #{user.name}"
      main_screen
    end

    def exit
     puts "goodbye fighter"
    end

    def main_screen
      system 'clear'
      user.reload
      sleep(0.6)
      puts "welcome fighter #{user.name}"
      prompt.select("choose an option") do |menu|
        menu.choice "choose a character",-> {choose_character}
        menu.choice "main menu",-> {menu_choice}
        menu.choice "switch user", -> {log_in}
      end
    end
    

    def choose_character
      characters = Character.all_names
      choose_a_character = prompt.select("choose a fighter", characters)
      random_user = User.all.sample
      random_character = Character.all.sample
      create_game = Game.create(user_id: user.id, user2_id: random_user.id,  character_id: choose_a_character, character_id2: random_character.id )
    end
    # plants = Plant.all_names
    # chosen_plant_id = prompt.select("Which plant do you want to adopt?", plants)
    # affection = prompt.ask("From 1-10, how affectionate do you feel towards this plant?").to_i
    # pp = PlantParenthood.create(plant_id: chosen_plant_id, person_id: user.id, affection: affection)
    # puts "Congratulations! You have adopted #{pp.plant.species}!"
    # sleep(1)
    # main_screen
    #  1. choose a plant -> display a list of plant names
    #  2. create a new plant_parenthood between the user and the plant
    

end

