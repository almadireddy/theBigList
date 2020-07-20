//
//  The_Big_ListApp.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 6/30/20.
//

import SwiftUI
import Foundation


enum BigListColor : String, CaseIterable {
    case green, red, purple, orange, blue
}

public class BigListColorGradients {
    static func getGradient(color: BigListColor) -> Gradient {
        switch color {
        case .red:
            return Gradient(colors: [Color("DarkRed"), Color("LightRed")])
        case .green:
            return Gradient(colors: [Color("DarkGreen"), Color("LightGreen")])
        case .purple:
            return Gradient(colors: [Color("DarkPurple"), Color("LightPurple")])
        case .orange:
            return Gradient(colors: [Color("DarkOrange"), Color("LightOrange")])
        case .blue:
            return Gradient(colors: [Color("DarkBlue"), Color("LightBlue")])
        }
    }
}

public class TagColors {
    static func getColor(color: BigListColor) -> Color {
        switch color {
        case .red:
            return Color("DarkRed")
        case .green:
            return Color("DarkGreen")
        case .purple:
            return Color("DarkPurple")
        case .orange:
            return Color("DarkOrange")
        case .blue:
            return Color("DarkBlue")
        }
    }
}


let taskDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

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
