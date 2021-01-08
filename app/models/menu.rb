class Menu
    attr_reader :prompt
    attr_accessor :user, :user2

    @@game = []
    def initialize
        @prompt = TTY::Prompt.new
    end

    def main_menu
      banner
      @prompt.select("welcome to avatar fighting game, please choose an option") do |menu|
        menu.choice "log in", -> {log_in}
        menu.choice "sign up", -> {sign_up}
        menu.choice "exit", -> {exit_game}
      end
    end
   
    def sign_up
      name = @prompt.ask("choose a username")
      while  User.find_by(name: name) || name == "" || name == nil
        if User.find_by(name: name)
        puts "that name is already taken "
        elsif name == "" || name == nil
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
      line_separator
      @prompt.select("choose an option") do |menu|
        menu.choice "start game",-> {game_instruction}
        menu.choice "logout",-> {main_menu}
        
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
       line
      end

    end

    def choose_character
      system 'clear'
      line_separator
      characters = Character.all_names
      choose_a_character = @prompt.select("choose a fighter", characters)
      random_user = User.all.sample
      random_character = Character.all.sample
      create_game = Game.create(user_id: user.id, user2_id: random_user.id, character_id: choose_a_character, character_id2: random_character.id, result: "")
      choose_skill
    end

    def choose_skill

      line_separator
        user1_hp = 100
        user2_hp = 100
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
        puts round_1.colorize(:blue) if count == 0
        puts round_2.colorize(:red) if count == 1
        puts round_3.colorize(:yellow) if count == 2
        puts round_4.colorize(:black) if count == 3
        chosen_skills = @prompt.select("choose your skill", ei.skill_1, ei.skill_2, ei.skill_3, ei.skill_4)
        chosen_skills_2 = [ei2.skill_1, ei2.skill_2, ei2.skill_3]
        random_skill = chosen_skills_2.sample
        random_skill = ei2.skill_4 if user2_energy >= 100


        if chosen_skills == ei.skill_1 
          user1_skill_points = 20
          user1_energy += 40 
          user1_heal = 0
          user2_hp -= user1_skill_points
        elsif chosen_skills == ei.skill_2
          user1_skill_points = 10
          user1_energy += 60 
          user1_heal = 30
          user2_hp -= user1_skill_points
          user1_hp += user1_heal
        elsif chosen_skills == ei.skill_3
          user1_skill_points = 30
          user1_energy += 30 
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
          user2_energy += 40 
          user2_heal = 0
          user1_hp -= user2_skill_points
          elsif random_skill == ei2.skill_2
            user2_skill_points = 10
            user2_energy += 60 
            user2_heal = 30
            user1_hp -= user2_skill_points
            user2_hp += user2_heal
          elsif random_skill == ei2.skill_3
            user2_skill_points = 30
            user2_energy += 30 
            user2_heal = 10
            user1_hp -= user2_skill_points
            user2_hp += user2_heal
          elsif random_skill == ei2.skill_4 && user2_energy >= 100
            user2_skill_points = 90
            user2_energy = 0
            user2_heal = 0 
            user1_hp -= user2_skill_points
          end
        puts "You chose #{ci.name} to use #{chosen_skills}"
        puts "#{ci.name} has #{user1_hp} Health, and #{user1_energy} Energy points"
        puts "The enemy#{ci2.name} used #{random_skill}"
        puts "#{ci2.name} has #{user2_hp} Health, and #{user2_energy} Energy points"

          count += 1
          sleep(3.5)
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
        line_separator
        @prompt.select("wouuld you like to play again") do |menu|
          menu.choice "yes",-> {choose_character}
          menu.choice "no",-> {main_screen}
        end
        
      end

      def user_stats
        line_separator
        game_select = Game.all.select{|game|game.user_id == user.id}
        wins = game_select.select{|games|games.result == "win"}
        loses = game_select.select{|games|games.result == "lose"}
        ties = game_select.select{|games|games.result == "tie"}
        @prompt.select("stats") do |menu|
          menu.choice "wins", -> {puts "you have #{wins.count} games won"}
          menu.choice "loses", -> {puts "you have #{loses.count} games lost"}
          menu.choice "ties", -> {puts "you have #{ties.count} games tied"}
          line_separator_2
          menu.choice "main menu", -> {main_screen}
        end
        user_stats
      end


      def delete_account
        line_separator
        deleted_user =self.user
        deleted_user.destroy
        puts "YOUR ACCOUNT HAS BEEN DELETED!"
        sleep(0.8)
        main_menu

      end
      
      def exit_game
        puts "goodbye fighter"
        exit
      end 
      def line_separator
        18.times do
          print "🔥 🌊 🌪 🪨 "
        end
      end
      
      def banner
        
        puts "
                                        ``````````                              
                                    ```-/syddddhs+-```                          
                                  ``-smMMMMMMMMMMMMNs-``                        
                                 `.yMMMMMMMMMMMMMMMMMMy``                       
                                `.mMMMMMMMMMMMMMMMMMMMMm.`                      
                               ``dMMMMMMMM``````MMMMMMMMm``                     
                              ``/MMMMMMMMM``````NMMMMMMMMs``                    
                              ` hMMMMMMMMM      +MMMMMMMMN `                    
                              ` NMMMMMM            ydMMMMMMM.`                    
                             `` MMMMMMMN+`       +NMMMMMMM.```                  
                           ``/hdMMMMMMMMMh-    -hMMMMMMMMMdho `                 
                           ` mMMMMMMMNNMMMNo``oNMMNmmMMMMMMMN `                 
                           ` yMMMMMm-``./hMMddMMh/.``-mMMMMMh `                 
                            ``yMMMMh      /MMMMo`     sMMMMh.`                                  
                            ``:ymMMh/-...-NMMM-.`.-/yNMmy:``                   
                              ``.yMMMNNNNNMMMMNmmmNMMMh.``                     
                               `.`yMMMMMMMMMMMMMMMMMMh.``                      
                                ``/d//hNMMMMMMMMMMMMNh++h+``                     
                                `-MMdyosdNMMMMMMmhsoymMM+``                     
                               ````NMMMMmhssyhdyoshmMMMMN-```                    
                           ``.-/ohdMMMMMMMMNy.`hNMMMMMMMMmhs/-.``                
                        `./ydNMMMMMMMMMMMMMMdoMMMMMMMMMMMMMMNmy/``                                             
                      ``:dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd:``            
                     ``:NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN/``           
                    ``/NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN/``          
                   ``+NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo``         
                 ```yMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMh``        
             ``.-+hMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMd/-.``    
            ``:ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmh/``  
            ``sMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMs``  
          ``oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNs.` 
          ``/MMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMMMMMMMMs``
          ``sMMMMMMMMMMMMMMMMMMMMMMhhh./yNMMMMmo::yydMMMMMMMMMMMMMMMMMMMMMMd.` 
           ``/mMMMMMMMMMMMMMMMMMMMM-.. `.oNMMm/` `--+MMMMMMMMMMMMMMMMMMMMN+``  
            ``+dmdso+ossyhhNMMMMMMMMMsdMMMMMMMNhhMMMMMMMMMNhhysoo++shmdo.``   
             `````````````:MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM/``````````````     
                         ` hMMMMMMMMMMMMMMMMMMMMMMMMMMMMd `                  
                           .:oymMMMMMMMMMMMMMMMMMMNhs/.``                   
                            ````.:+oyhhddddhyso/:.````                      
                                 ``````````````   
                                 "

      end
      
      def round_1
       "      
       ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌        ▄█░░░░▌    
       ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌      ▐░░▌▐░░▌    
       ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌       ▀▀ ▐░░▌    
       ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌          ▐░░▌    
       ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌          ▐░░▌    
       ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌          ▐░░▌    
       ▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌          ▐░░▌    
       ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌      ▄▄▄▄█░░█▄▄▄ 
       ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌
         "
      end

      def round_2
        "   
        ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌      ▀▀▀▀▀▀▀▀▀█░▌
        ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌               ▐░▌
        ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌               ▐░▌
        ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌      ▄▄▄▄▄▄▄▄▄█░▌
        ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌
        ▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ 
        ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
        ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌
         
          "
       end

       def round_3
        " 
        ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌      ▀▀▀▀▀▀▀▀▀█░▌
        ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌               ▐░▌
        ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌      ▄▄▄▄▄▄▄▄▄█░▌
        ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
        ▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌               ▐░▌
        ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌      ▄▄▄▄▄▄▄▄▄█░▌
        ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌      ▐░░░░░░░░░░░▌
         
        "
       end 
       
        def round_4
        "  
         ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄        ▄         ▄ 
        ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌      ▐░▌       ▐░▌
        ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌       ▐░▌
        ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌       ▐░▌     ▐░▌       ▐░▌
        ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌
        ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌     ▐░░░░░░░░░░░▌
        ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
        ▐░▌     ▐░▌  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌       ▐░▌               ▐░▌
        ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌               ▐░▌
        ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌                ▐░▌
         ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀                  ▀ "
      end
      
      def line
       156.times do
        print"-"
       end
      end
      
end
