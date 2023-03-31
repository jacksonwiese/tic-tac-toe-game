//
//  GameView.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/31/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game:GameService
    
    //This dismiss variable to dismisses the page once activated (aka goes back to the hoem screen)
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy{ $0 == false }{
                Text("Select a player to start")
            }
            
            HStack{
                Button(game.player1.name){
                    game.player1.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                
                
                Button(game.player2.name){
                    game.player2.isCurrent = true
                    if game.gameType == .bot{
                        Task{
                            await game.deviceMove()
                        }//end of task
                    }//end of bot logic
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
                
            }//end of hstack
            .disabled(game.gameStarted)
            
            //create a gameboard
            VStack{
                HStack{
                    ForEach(0...2, id:\.self){
                        index in SquareView(index: index)
                    }
                }//end of first HStack
                
                HStack{
                    ForEach(3...5, id:\.self){
                        index in SquareView(index: index)
                    }
                }//end of second HStack
                
                HStack{
                    ForEach(6...8, id:\.self){
                        index in SquareView(index: index)
                    }
                }//end of third HStack
                
            }//end of VStack
            .disabled(game.boardDisabled) //game is instance, boardDisabled is a variable(bool)
            .overlay{
                if game.isThinking{
                    VStack{
                        Text("Thinking...")
                            .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }//emnd of if
            }
            
            VStack{
                //Result layout of the UI
                if game.gameOver{
                    Text("Game Over")
                    if game.possibleMoves.isEmpty{
                        Text("It's a draw!")
                    }//end of isempty check
                    else{
                        Text("\(game.currentPlayer.name) wins")
                    }//end of else
                    
                    //this button for a new game once a tie/winner has been declared
                    Button("New Game") {
                        game.reset()
                    
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            
            Spacer()
            
        }//end of full screen VStack
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Game") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }//end toolbaritem
        }//end toolbar
        .navigationTitle("Cross Over")
        .onAppear{game.reset()}
        .inNavigationStack()
    }//end View
}//end struct

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
        .environmentObject(GameService())
    }
}//end of gameview struct

struct PlayerButtonStyle:ButtonStyle{
    let isCurrent:Bool
    
    //use makeBody creating our own modifier
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(isCurrent ? Color.green:Color.gray)) //if true (?) this(1) or that(2)
            .foregroundColor(.white)
            
    }
}
