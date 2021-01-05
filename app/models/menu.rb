class Menu
    attr_reader :prompt
    attr_accessor :user

    @@game = []
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
       # menu.choice "current game", ->{game_helper}
      end
    end
    

    def choose_character
      characters = Character.all_names
      choose_a_character = prompt.select("choose a fighter", characters)
      random_user = User.all.sample
      random_character = Character.all.sample
      create_game = Game.create(user_id: user.id, user2_id: random_user.id, character_id: choose_a_character, character_id2: random_character)
      choose_skill
    end

    def self.choose_skill
      games = Game.last
      ci = Character.find_by(id: games.character_id)
      ei = Element.find_by(id: ci.element_id)
      ci2 = Character.find_by(id: games.character_id2)
      ei2 = Element.find_by(id: ci2.element_id)
      skills = [ei.skill_1, ei.skill_2, ei.skill_3, ei.skill_4]
      choose_skills = prompt.select("choose your skill", skills)
      winner = ei.id < ei2.id
      result = true if winner == true 
      if result == true
      puts "you win" 
      elsif
      puts "you lose" 
      end
      binding.pry
    end

      
end
