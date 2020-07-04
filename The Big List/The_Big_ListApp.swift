//
//  The_Big_ListApp.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 6/30/20.
//

import SwiftUI
import SQLite

@main
struct The_Big_ListApp: App {
    var myLists = [String: BigList]()
    
    var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}

struct The_Big_ListApp_Previews: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        Text("Hello, World!")
    }
}
