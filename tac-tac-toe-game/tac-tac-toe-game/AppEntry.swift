//
//  AppEntry.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/7/23.
//

import SwiftUI

//CLASS VS STRUCT
//class (REFERENCE TYPE): indep instances of class; can make duplicates class instances
//struct (VALUE TYPE): indep instances of struc; can't make duplictaes: all of them must be unique 9

@main
struct AppEntry: App {
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(game)
        }
    }
}
