//
//  GameService.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

//class is a similar structure of things (includes structures)
//@State can be canged by single variable
//@Enviroment view across different views
//@Published your data structure accross everhthing

//Thread creates instance xCode (want to tell XCode that this thread is very important and that it needs to run on the main thread)

import SwiftUI


@MainActor
class GameService:ObservableObject{
    @Published var player1 = Player(gamePiece: .x, name: "Player 1")
    @Published var player2 = Player(gamePiece: .o, name: "Player 2")
    @Published var possibleMoves = Moves.all
    @Published var movesTaken = [Int]()
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset //this property sets the game
    @Published var isThinking = false //for the bot gametype
    
    var gameType = GameType.single //hard coding to single, aka will import later
    
    //this sturcture decides which players turns or not
    var currentPlayer:Player{
        if player1.isCurrent{
            return player1
        } else{
            return player2
        }
    } //end of currentPlayer variable
    
    
    //checks to see if a game is started or not
    var gameStarted:Bool{
        player1.isCurrent || player2.isCurrent
        //if either player is the current player, then we automatcially know the game is started
    }
    
    var boardDisabled:Bool{
        gameOver || !gameStarted || isThinking
    }
    
    //function for setting up the game (imports game type, player1's name, and player2's name)
    func setupGame(gameType: GameType, player1Name: String, player2Name: String){
        
        switch gameType{
        case .single:
            self.gameType = .single
            player1.name = player1Name
            player2.name = player2Name
            
        case .bot:
            self.gameType = .bot
            player2.name = UIDevice.current.name
            
        case .peer:
            //we will fix this later
            self.gameType = .peer
            
            
        case .undetermined:
            //what should i do here
            break
        }
    }
    
    //this functions runs wheneevr we reset the board
    func reset(){
        player1.isCurrent = false
        player2.isCurrent = false
        player1.moves.removeAll()
        player2.moves.removeAll()
        gameOver = false
        possibleMoves = Moves.all
        gameBoard = GameSquare.reset
    }//end of func reset
    
    //this function runs every time we're trying to upate the move
    func updateMoves(index: Int){
        if player1.isCurrent{
            player1.moves.append(index+1)
            gameBoard[index].player = player1
        } else {
            player2.moves.append(index+1)
            gameBoard[index].player = player2
        }//end of else
    }//end of func update moves
    
    //Check for winner
    func checkIfWinner(){
        if player1.isWinner || player2.isWinner{
            gameOver = true
        }
    }//end of checkIfWinner
    
    //function for switching the current players
    func toggleCurrent(){
        player1.isCurrent.toggle()
        player2.isCurrent.toggle()
    }//end of toggle
    
    //For bot to be able to make move
    func makeMove(at index:Int){
        if gameBoard[index].player == nil{
            withAnimation{
                updateMoves(index: index)
            }//end of WithAnimation
        checkIfWinner()
            if !gameOver{
                if let matchingIndex = possibleMoves.firstIndex(where: {$0==(index+1)}){
                    possibleMoves.remove(at: matchingIndex)
                }//end of if statement
                toggleCurrent()
                
                //bot logic
                if gameType == .bot && currentPlayer.name == player2.name{
                    Task{
                        await deviceMove()
                    }//end of task
                }//end of bot if
                
            }//end of gameOver
            
            if possibleMoves.isEmpty{
                gameOver=true
            }
        }
    }//end of makeMove
    
    //function for the bot making the move
    func deviceMove() async{
        isThinking.toggle()
        
        //delay here is to simulate computer "thinking," aka needs a moment to make it's move
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        //randomly selecting a place on the board that hasn't been selected (bot has no strategy)
        if let move = possibleMoves.randomElement(){
            if let matchingIndex = Moves.all.firstIndex(where: {$0 == move}){
                makeMove(at: matchingIndex)
            }//end of inner if
            isThinking.toggle()
        }//end of outer if
    }//end of deviceMove
    
}//end of class
