//
//  BigList.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/3/20.
//

import Foundation

class BigListItem : Encodable {
    var id: Int64
    var listText: String
    var listId: Int64
    
    init(id: Int64, listText: String, listId: Int64) {
        self.id = id
        self.listText = listText
        self.listId = listId
    }
}

class BigList : Hashable, ObservableObject {
    @Published var id: Int64
    @Published var listName: String
    
    init(id: Int64, listName: String) {
        self.id = id
        self.listName = listName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(listName)
    }
}

func ==(lhs: BigList, rhs: BigList) -> Bool {
    return lhs.id == rhs.id
}
