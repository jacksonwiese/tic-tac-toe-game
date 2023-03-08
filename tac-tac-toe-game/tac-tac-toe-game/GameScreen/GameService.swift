//
//  GameService.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

import SwiftUI


@MainActor //following code is only accessible from the main thread
class GameService:ObservableObject{ //The class named GameService is an ObservableObject which means it is published and thus triggers updates to any vioews observing it
    
    //Global Variables
    @Published var player1 = Player(gamePiece: .x, name: "Player 1")
    @Published var player2 = Player(gamePiece: .o, name: "Player 2")
    @Published var possibleMoves = Moves.all
    @Published var movesTaken = [Int]()
    @Published var gameOver = false
    @Published var gameBoard = GameSquare.reset
    @Published var isThinking = false //for the bot gametype
    
    var gameType = GameType.single
    
    var currentPlayer:Player {
        if player1.isCurrent{
            return player1
        } else {
            return player2
        }
        
        //if either player is active, the game has started
        var gameStarted:Bool{
            player1.isCurrent || player2.isCurrent
        }
        
        //3 factors that can disable the board
        var boardDisabled:Bool {
            gameOver || !gameStarted || isThinking
        }
        
        //function to setup the game (runs with the given game type and plugs information in different spots
        func setupGame(gameType: GameType, player1Name: String, player2Name: String){
            
            switch GameType {
                case .single:
                    self.gameType = .single
                    player1.name = player1Name
                    player2.name = player2Name
                
                case .bot:
                    self.gameType = .bot
                    player1.name = player1Name
                    player2.name = UIDevice.current.name //the opponent will be the device's name
                
                case .peer:
                    //note: this requires more features to make bluetooth compatible, so we will disable it until those features are added
                    self.gameType = .peer
                
                case .undetermined:
                    break
            }
        }
        
        //function to reset the game
        func reset() {
            
            //reset player settings
            player1.isCurrent = false
            player2.isCurrent = false
            player1.moves.removeAll()
            player2.moves.removeAll()
            
            //reset game board
            gameOver = false //the game is no longer over
            possibleMoves = Moves.all //reset possible moves
            gameBoard = GameSquare.reset //reset each gamesquare on the gameboard
        }
        
        //this function updates the moves
        func updateMoves(index: Int) {
            if player1.isCurrent{
                player1.moves.append(index+1)
                gameBoard[index].player = player1
            } else {
                player2.moves.append(index+1)
                gameBoard[index].player = player2
            }
        }
        
        //reoccuring function that ends the game once a winner is declared
        func checkIfWinner(){
            if player1.winner || player2.winner{
                gameOver = true
            }
        }
        
        //this function turns one player as the inactive player and flips the over player to be the active player
        func toggleCurrent() {
            player1.isCurrent.toggle()
            player2.isCurrent.toggle()
        }
        
        func makeMove(at index: Int){
            if gameBoard[index].player == nil {
                withAnimation(){
                    updateMoves(index: index)
                }
            }
            checkIfWinner()
            if !gameOver {
                if let matchingIndex = possibleMoves.firstIndex(where: {$0==(index+1)}) {
                    possibleMoves.remove(at: matchingIndex)
                }
                toggleCurrent()
                
                //What the bot should do
                if gameType = .bot && currentPlayer.name = player2.name {
                    Task{
                        await deviceMove()
                    }
                }
            }
            
            //if all spots on the tic tac toe board have been made (thus no possible moves are left) the game is over
            if possibleMoves.isEmpty {
                gameOver = true
            }
        }
        
        //for the player vs. bot function: this function makes a move for the bot
        func deviceMove() async{
            isThinking.toggle()
            
            try? await Task.sleep(nanoseconds: 600_000_000)
            
            if let move = possibleMoves.randomElement(){
                if let matchingIndex = Moves.all.firstIndex(where: {$0 == move}) {
                    makeMove(at: matchingIndex)
                }
                isThinking.toggle()
            }
        }
    }
}
