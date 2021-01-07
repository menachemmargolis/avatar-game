class Menu
    attr_reader :prompt
    attr_accessor :user, :user2

    @@game = []
    def initialize
        @prompt = TTY::Prompt.new
    end

    def main_menu
      @prompt.select("welcome to avatar fighting game, please choose an option") do |menu|
        menu.choice "log in", -> {log_in}
        menu.choice "sign up", -> {sign_up}
        menu.choice "exit", -> {exit_game}
      end
    end
   
    def sign_up
      name = @prompt.ask("choose a username")
     while  User.find_by(name: name) || name = nil || name = ""
        if User.find_by(name: name)
        puts "that name is already taken "
        elsif name = nil || name = ""
        puts "that is not a valid username, a username must contain at least one character " 
        end
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

    def main_screen
      system 'clear'
      user.reload
      sleep(1.3)
      
      puts "welcome fighter #{user.name}"
      @prompt.select("choose an option") do |menu|
        menu.choice "start game",-> {game_instruction}
        menu.choice "logout",-> {main_menu}
        #menu.choice "current game", ->{game_helper}
        menu.choice "see curent stats", -> {user_stats}
        menu.choice "delete account", ->{delete_account}
      end
    end
    
    def game_instruction
      puts "the game is as follows, you will choose a character and based on the 
      characters element you will have 4 diffrent skills,
      the last skill which is worth the most points is only availeble if you have 100 energy points, 
      each player will start off with 100 health points and zero energy points,
      each skill is worth a certian amount of energy points, 
      and deducts a certian amount of health points from the enemy,
      whoever has the most health points after three rounds wins. "
      @prompt.select("press enter to start game") do |menu|
       menu.choice "enter", -> {choose_character}
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
          
#           print "Please,select skill!"
# skill = gets.chomp.to_s
# case skill
#     when chosen_skills == ei.skill_1 
      # then user1_skill_points = 20
      # user1_energy += 30 
      # user1_heal = 0
      # user2_hp -= user1_skill_points
#     when 2 then print "This is February!"
#     when 3 then print "This is March!"
#     when 4 then print "This is April!"
#     when 5 then print "This is May!"
#     when 6 then print "This is June!"
#     when 7 then print "This is July!"
#     when 8 then print "This is August!"
#     when 9 then print "This is September!"
#     when 10 then print "This is October!"
#     when 11 then print "This is November!"
#     when 12 then print "This is December!"
#     else print "I can't undestand you, i'm sorry!"
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
          sleep(1.8)
          play_again
      end

      def play_again
        @prompt.select("wouuld you like to play again") do |menu|
          menu.choice "yes",-> {choose_character}
          menu.choice "no",-> {exit_game}
        end
        
      end

      def user_stats
        game_select = Game.all.select{|game|game.user_id == user.id}
        wins = game_select.select{|games|games.result == "win"}
        loses = game_select.select{|games|games.result == "lose"}
        ties = game_select.select{|games|games.result == "tie"}
        @prompt.select("stats") do |menu|
          menu.choice "wins", -> {puts "you have #{wins.count} games won"}
          menu.choice "loses", -> {puts "you have #{loses.count} games lost"}
          menu.choice "ties", -> {puts "you have #{ties.count} games tied"}
          menu.choice "main menu", -> {main_screen}
        end
        user_stats
      end


      def delete_account

        deleted_user =self.user
        #delete_games = Game.all.reject{|games|games if games.user_id == deleted_user.id}
        deleted_user.destroy
        puts "YOUR ACCOUNT HAS BEEN DELETED!"
        sleep(0.8)
        main_menu

      end
      
      def exit_game
        puts "goodbye fighter"
        exit
      end 
      
      
end
