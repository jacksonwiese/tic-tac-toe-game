//
//  tac_tac_toe_gameApp.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(game)
        }
    }
}
