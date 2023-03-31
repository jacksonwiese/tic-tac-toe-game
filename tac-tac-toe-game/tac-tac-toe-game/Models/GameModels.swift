//
//  GameModels.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/31/23.
//

import SwiftUI

//numerative data type creates a bunch of variables and puts them in order
enum GameType { //both letter are capital bc like structure
case single, bot, peer, undetermined
    
    var description: String {
        switch self {
        case .single: //.single referencing to a class or a structure
            return "Share your device and play against a friend"
        case .bot:
            return "Play with your device"
        case .peer:
           return "Invite with the app someone near you  and play"
        case .undetermined:
            return "" //start the game for the first time, let there be nothing in there
        }
    }
}

//only two static types of chess pieces so enum
enum GamePiece: String{
    case x,o
    var image:Image{
        Image(self.rawValue)
    }
}

struct Player{
    let gamePiece:GamePiece
    var name:String
    var moves:[Int] = []
    var isCurrent = false
    var isWinner:Bool {
        for moves in Moves.winningMoves{
            if moves.allSatisfy(self.moves.contains){
                return true
            }
        }//the entire for loop needs to go through all the options to see if there are any wins then it return false if there are none
        return false
    }
    
}

//fixed datatypes use enum
enum Moves{
    static var all = [1,2,3,4,5,6,7,8,9]
    static var winningMoves = [
        //Horizontal matching
        [1,2,3],
        
        [4,5,6],
        
        [7,8,9],
 
        //Vertical matching
        [1,
        4,
        7],
        
        [2,
        5,
        8],
        
        [3,
        6,
        9],
        
        //Diagonal matching
        [1,
            5,
                9],
        
                [3,
            5,
        7]
        
    ]
}
