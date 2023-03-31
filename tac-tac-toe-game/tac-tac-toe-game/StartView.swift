//
//  StartView.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

import SwiftUI

struct StartView: View {
    //state properties: @State (can be tracked outside this file)
    //@Published updates anything across the entire UI
  
    //game type is undedetermined to start
    @State private var gameType:GameType = .undetermined
    
    //players name
    @State private var yourName = ""
    
    //opp name
    @State private var opponentName = ""
    
    //whether the keybaord is up or no
    @FocusState private var focus:Bool
    
    //Check to see if the game has started
    @State private var startGame = false
    
    //the variable game is of the gameservice data type
    @EnvironmentObject var game:GameService
    
    //GUID changes every second (aka unqiue identifier)
    //We run randomization on random number
    
    //Navigation Stack only for IOS 16 - we have to use nav view instead
    var body: some View {
        VStack {
            Picker("Select Game",selection: $gameType) {
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Two sharing device").tag(GameType.single)
                Text("Challenge your device").tag(GameType.bot)
                Text("Challenge a friend").tag(GameType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(style: StrokeStyle(lineWidth: 2)).accentColor(.primary))
            
            Text(gameType.description)
                .padding()
            
            //vstack to hold our text field asking for the name
            //how many text field depends upon the type of game we play
            VStack{
                
                //the game will react based on what the user selected from the menu
                switch gameType {
                    
                //for when the player selects single player mode
                case .single:
                    TextField("Your Name", text: $yourName)
            TextField("Opponent Name", text: $opponentName)
                    
                case .bot:
                    TextField("Your Name",  text: $yourName)
                    
                case .peer:
                    //keeping as EmptyView until we have bluetooth capabilities
                    EmptyView()
                    
                case .undetermined:
                    //empty view until we know what game type the user wants
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus) //focus here is whether to have keyboard or no keyboard on the screen
            .frame(width:350)
            
            //data validation to start game includes: names for player 1 and player 2 and the game type must be single player or two sharing a device
            if gameType != .peer{ //will update once bluetooth feature is added
                Button("Start Game"){
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus=false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .bot && yourName.isEmpty ||
                    gameType == .single && (yourName.isEmpty || opponentName.isEmpty)
                )
                Image("HomePicture") //basic picture here
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
      Spacer()
            
        }//end of vstack
        .padding()
        .fullScreenCover(isPresented: $startGame){
            GameView()
        }
        .navigationTitle("Tic-Tac-Toe")
        .inNavigationStack()
    }//end of body
}//end of struct

//Content View for XCode
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(GameService())
    }
}
