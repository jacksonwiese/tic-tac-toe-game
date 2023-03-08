//
//  StartView.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

import SwiftUI

struct StartView: View {
    //Global Variables defined here:
    @State private var gameType:GameType = .undetermined
    @State private var yourName = ""
    @State private var opponentName = ""
    @FocusState private var keyboardActive:Bool //defaults to false
    @State private var startGame = false //once the player selects "Start game" this will be switched to true until the user ends the game (and does not choose to play another game)
    @EnvironmentObject var game:GameService
    
    var body: some View {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
