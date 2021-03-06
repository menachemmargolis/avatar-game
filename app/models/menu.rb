class Menu
    attr_reader :prompt
    attr_accessor :user, :user2

    @@game = []
    def initialize
        @prompt = TTY::Prompt.new
    end

    def menu_choice
      @prompt.select("welcome to avatar fightinh game, please choose an option") do |menu|
        menu.choice "log in", -> {log_in}
        menu.choice "sign up", -> {sign_up}
        menu.choice "exit", -> {exit}
      end
    end

    def sign_up
      name = @prompt.ask("choose a username")
      while User.find_by(name: name)
        puts "that name is already taken"
        name = @prompt.ask("choose another username")
      end
      self.user = User.create(name: name)
      puts "welcome #{user.name}"
      main_screen
    end

    def log_in
      name = @prompt.ask("enter username")
      while !User.find_by(name: name)
        puts "wrong username"
        name = @prompt.ask("please enter correct username")
      end
      self.user = User.find_by(name: name)
      puts "welcome #{user.name}"
      sleep(1.2)
      main_screen
    end

    def exit
     puts "goodbye fighter"
    end

    def main_screen
      system 'clear'
      user.reload
      sleep(1.3)
      
      puts "welcome fighter #{user.name}"
      @prompt.select("choose an option") do |menu|
        menu.choice "choose a character",-> {choose_character}
        menu.choice "main menu",-> {menu_choice}
        menu.choice "switch user", -> {log_in}
        menu.choice "current game", ->{game_helper}
        menu.choice "delete account", ->{delete_account}
      end
    end
    

    def choose_character
      characters = Character.all_names
      choose_a_character = @prompt.select("choose a fighter", characters)
      random_user = User.all.sample
      random_character = Character.all.sample
      create_game = Game.create(user_id: user.id, user2_id: random_user.id, character_id: choose_a_character, character_id2: random_character.id, result: "")
      choose_skill
    end

    def choose_skill
        user_skill_points = 0 
        user2_skill_points = 0
        games = Game.last
        #game_to_update = Game.all.find{|game|game.id == games.id}
        ci = Character.find_by(id: games.character_id)
        ei = Element.find_by(id: ci.element_id)
        ci2 = Character.find_by(id: games.character_id2)
        ei2 = Element.find_by(id: ci2.element_id)
        skills = Element.all_skill
        chosen_skills = @prompt.select("choose your skill", ei.skill_1, ei.skill_2, ei.skill_3, ei.skill_4)
        chosen_skills_2 = [ei2.skill_1, ei2.skill_2, ei2.skill_3, ei2.skill_4]
        random_skill = chosen_skills_2.sample
        if chosen_skills == ei.skill_1 
        user_skill_points = 10 
        elsif chosen_skills == ei.skill_2
          user_skill_points = 5
        elsif chosen_skills == ei.skill_3
          user_skill_points = 25
        elsif chosen_skills == ei.skill_4
          user_skill_points = 40
        end
        
        if random_skill == ei2.skill_1 
          user2_skill_points = 10 
          elsif random_skill == ei2.skill_2
            user2_skill_points = 5
          elsif random_skill == ei2.skill_3
            user2_skill_points = 25
          elsif random_skill == ei2.skill_4
            user2_skill_points = 40
          end

          if user_skill_points > user2_skill_points 
            puts "you win!"
            games.update(result: "win")
          elsif user_skill_points == user2_skill_points
            puts "it's a tie!"
            games.update(result: "tie")
          else user_skill_points < user2_skill_points
            puts "you lose!"
            games.update(result: "lose")
          end

      end
        
      def game_helper
        choose_skill
      end

      def delete_account
        deleted_user =self.user
        #delete_games = Game.all.reject{|games|games if games.user_id == deleted_user.id}
        deleted_user.destroy
        puts "YOUR ACCOUNT HAS BEEN DELETED!"
        sleep(0.8)
        menu_choice
      end
      def player2

      end
end
