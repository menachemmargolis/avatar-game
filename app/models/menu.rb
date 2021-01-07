class Menu
    attr_reader :prompt
    attr_accessor :user, :user2

    @@game = []
    def initialize
        @prompt = TTY::Prompt.new
    end

    def menu_choice
      @prompt.select("welcome to avatar fighting game, please choose an option") do |menu|
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
        user1_hp = 100
        user2_hp = 100
        # user1_final_hp = user1_hp.clamp(0, 100)
        # user2_final_hp = user2_hp.clamp(0, 100)

        user1_skill_points = 0
        user1_energy = 0 
        user1_heal = 0
        user2_skill_points = 0
        user2_energy = 0
        user2_heal = 0 
        count = 0
        games = Game.last
        ci = Character.find_by(id: games.character_id)
        ei = Element.find_by(id: ci.element_id)
        ci2 = Character.find_by(id: games.character_id2)
        ei2 = Element.find_by(id: ci2.element_id)
        skills = Element.all_skill
      while count < 4
        system 'clear'
        chosen_skills = @prompt.select("choose your skill", ei.skill_1, ei.skill_2, ei.skill_3, ei.skill_4)
        chosen_skills_2 = [ei2.skill_1, ei2.skill_2, ei2.skill_3, ei2.skill_4]
        random_skill = chosen_skills_2.sample

        if chosen_skills == ei.skill_1 
          user1_skill_points = 20
          user1_energy += 30 
          user1_heal = 0
          user2_hp -= user1_skill_points
        elsif chosen_skills == ei.skill_2
          user1_skill_points = 5
          user1_energy += 50 
          user1_heal = 30
          user2_hp -= user1_skill_points
          user1_hp += user1_heal
        elsif chosen_skills == ei.skill_3
          user1_skill_points = 30
          user1_energy += 10 
          user1_heal = 10
          user2_hp -= user1_skill_points
          user1_hp += user1_heal
        elsif chosen_skills == ei.skill_4 && user1_energy >= 100
          user1_skill_points = 90
          user1_energy = 0 
          user1_heal = 0
          user2_hp -= user1_skill_points
        end

        if random_skill == ei2.skill_1 
          user2_skill_points = 20
          user2_energy += 30 
          user2_heal = 0
          user1_hp -= user2_skill_points
          elsif random_skill == ei2.skill_2
            user2_skill_points = 5
            user2_energy += 50 
            user2_heal = 30
            user1_hp -= user2_skill_points
            user2_hp += user2_heal
          elsif random_skill == ei2.skill_3
            user2_skill_points = 30
            user2_energy += 10 
            user2_heal = 10
            user1_hp -= user2_skill_points
            user2_hp += user2_heal
          elsif random_skill == ei2.skill_4 && user2_energy >= 100
            user2_skill_points = 90
            user2_energy = 0
            user2_heal = 0 
            user1_hp -= user2_skill_points
          end

          # if user_skill_points > user2_skill_points 
          #   puts "you win!"
          #   games.update(result: "win")
          # elsif user_skill_points == user2_skill_points
          #   puts "it's a tie!"
          #   games.update(result: "tie")
          # else user_skill_points < user2_skill_points
          #   puts "you lose!"
          #   games.update(result: "lose")
          # end

        puts "You chose #{ci.name} to use #{chosen_skills}"
        puts "#{ci.name} has #{user1_hp} Health, and #{user1_energy} Energy points"
        puts "The enemy#{ci2.name} used #{random_skill}"
        puts "#{ci2.name} has #{user2_hp} Health, and #{user2_energy} Energy points"

          count += 1
          sleep(5.5)
        end
          if user1_hp > user2_hp
            puts "you win!"
            games.update(result: "win")
          elsif user1_hp == user2_hp
            puts "it's a tie!"
            games.update(result: "tie")
          else user1_hp < user2_hp
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
