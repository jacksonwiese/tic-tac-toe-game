//
//  SquareView.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/31/23.
//

import SwiftUI

struct SquareView: View {
    //to access the GameService class in this view
    @EnvironmentObject var game:GameService
    
    //helps us track the tiles from 1-9
    let index: Int
    
    var body: some View {
        Button{
            if !game.isThinking{
                game.makeMove(at: index)
            }
            
        } label: {
            game.gameBoard[index].image
                .resizable()
                .frame(width:75, height: 75) //the boundary has a height
                .border(.primary)
        }
        .disabled(game.gameBoard[index].player != nil)
    }
}

struct SquareView_Previews: PreviewProvider {
    static var previews: some View {
        SquareView(index: 1)
            .environmentObject(GameService())
        //give an instance to the class, so that this structure belongs to instance of this class
    }
}

