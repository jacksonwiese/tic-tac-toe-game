//
//  ViewModifier.swift
//  tac-tac-toe-game
//
//  Created by Jackson Wiese on 3/31/23.
//


//This file makes tic-tac-toe be compatible for older iOS devices

import SwiftUI

struct NavStackContainer:ViewModifier{
    
    func body(content: Content) -> some View { //function checking for IOS version
        if #available(iOS 16, *){ //want to run the Navigation Stack
            NavigationStack{
                content
            }
        } else {
            NavigationView{
                content
            }
            .navigationViewStyle(.stack) //the view style is a stack
        }
    }
}

extension View{
    public func inNavigationStack()->some View{
        return self.modifier(NavStackContainer()) //returns the NavStackContainer given the content editted based on the iOS version
    }
}
