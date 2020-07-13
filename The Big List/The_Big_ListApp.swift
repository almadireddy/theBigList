//
//  The_Big_ListApp.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 6/30/20.
//

import SwiftUI
import Foundation

@main
struct The_Big_ListApp: App {
    let context = PersistentContainer.persistentContainer.viewContext
    let store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
                .environmentObject(store)
        }
    }
}

struct The_Big_ListApp_Previews: PreviewProvider {
    
    static var previews: some SwiftUI.View {
        Text("Hello, World!")
    }
}
