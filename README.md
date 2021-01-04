# avatar-game
a interactive game where you can  compete against other avatars 

Domain model with attributes (also foreign keys):

User -< Game >- Character -< Element

User: name(str), user_id(int)
Game: user_id(int),user_id2(int),character_id(int),character_id2(int), result(boolean)
Character: name (str), elements(int)
Element: name(str), skill_id(int), skill_id2(int),skill_id3(int), power(int)

User Stories (remember about CRUD):
Mvp

User will be able to:
Choose a Character,
Change elements of Character,
Quit the Game
Destroy account

Game will be able to:
Compare each Character
Show Result of the game
Character will be able to:
Assign element
Element will be able to:
Access power
Choose a skill


Stretch Goal

User will be able to:
log into the application,
Change elements of Character
See the Game Results
Game will be able to:
Easter Egg
Make Team
Character will be able to:
Choose element to use
Switch element
Element will be able to:
Choose a hidden skill

Avatar The Fighting Arena Game. It allows you to choose your character, element and skills, let you fight with another player or the computer.