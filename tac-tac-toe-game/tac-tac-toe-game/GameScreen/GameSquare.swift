//
//  GameSquare.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/31/23.
//

import SwiftUI

struct GameSquare{
    var id:Int //to track tiles 1 to 16
    var player: Player?
    var image:Image{
        if let player = player{
            return player.gamePiece.image
        }
        else{
            return Image("none")//this is the empty image in assets
        }
    }//end of Image
    
    //reset function clears all the images
    static var reset:[GameSquare]{
        var squares=[GameSquare]()
        for index in 1...16{
            squares.append(GameSquare(id: index))
        }
        return squares
    }
    
}//end of struct

