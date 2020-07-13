//
//  AppState.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/13/20.
//

import Foundation

enum SheetType {
    case newListItem, editListItem, listSettings
}

class AppStore : ObservableObject {
    struct AppState {
        var selectedSheet : SheetType
    }
    
    @Published private(set) var state =
        AppState(selectedSheet: SheetType.newListItem)
    
    func setSelectedSheet(_ sheetType: SheetType) {
        state.selectedSheet = sheetType
    }
}
