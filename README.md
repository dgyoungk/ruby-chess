# TOP FS Ruby: Ruby Course Final Project

## Chess that can be played from the command line

### Classes
    - Board
    - Node
    - ChessPiece (Superclass of all the pieces in the game)
    - Game
    - Player

### Modules
    - BasicSerializable: allows state-saving to text file using Marshal
    - Colorable: houses chess board and chess piece coloring methods
    - Displayable: houses all game display methods
    - Fileable: houses all game saving and game loading methods
    - Informable: houses gameplay logic methods
    - Movable: houses gameplay logic methods
    - Occupiable: houses methods that initialize the chess board with pieces
    - Playable: houses gameplay logic methods
    - Promptable: houses all user input prompting methods
    - Retrievable: houses methods that retrieve gameplay info
    - Thinkable: houses all the predicate methods involved in gameplay logic
    - ChessLogic: namespace module for all the modules

### Playing the game:
    - clone this repo to your desired folder
    - open your command line and cd into the folder where the repo is
    - run ruby lib/main.rb



Author: Daniel Kwon 2024
