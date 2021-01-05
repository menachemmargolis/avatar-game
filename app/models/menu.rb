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
      end
    end
    

    def choose_character
      characters = Character.all_names
      choose_a_character = prompt.select("choose a fighter", characters)
      random_user = User.all.sample
      random_character = Character.all.sample
      create_game = Game.create(user_id: user.id, user2_id: random_user.id,  character_id: choose_a_character.id, character_id2: random_character.id)
      game_helper
    end

    def game_helper
      games = Game.last
      choose_a_game = prompt.select("choose a game", games)
    end
end
