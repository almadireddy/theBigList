//
//  AppState.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/3/20.
//

import Foundation
import SQLite

class AppState : ObservableObject {
    @Published var lists: [BigList]
    private var db: Connection;
    
    private static let listTable = Table("lists")
    private static let id = Expression<Int64>("id")
    private static let listName = Expression<String>("list_name")
    private static let listItemTable = Table("list_items")
    private static let listItemName = Expression<String>("list_item_name")
    private static let listId = Expression<Int64>("list_id")
    private static let tagTable = Table("tags")
    private static let tagName = Expression<String>("tag_name")
    private static let tagListTable = Table("tag_lists")
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            db = try Connection("\(path)/appDb.sqlite3")
            
            // list : | id | list_name |
            // list_items : | id | list_name_name | list_id |
            // tags : | tag_name |
            // tag_list : | tag_name | list_id |
            
            try db.run(AppState.listTable.create(ifNotExists: true) { t in
                t.column(AppState.id, primaryKey: .autoincrement)
                t.column(AppState.listName, unique: true)
            })
            
            try db.run(AppState.listItemTable.create(ifNotExists: true) { t in
                t.column(AppState.id, primaryKey: .autoincrement)
                t.column(AppState.listItemName)
                t.column(AppState.listId, references: AppState.listTable, AppState.id)
            })
            
            try db.run(AppState.tagTable.create(ifNotExists: true) { t in
                t.column(AppState.tagName, primaryKey: true)
            })
            
            try db.run(AppState.tagListTable.create(ifNotExists: true) {t in
                t.column(AppState.tagName, primaryKey: true)
                t.column(AppState.listId, references: AppState.listTable, AppState.id)
            })
            
            let allListsQuery  = Array(try db.prepare(AppState.listTable))
            let allLists = try allListsQuery.map({ row in
                BigList(id: try row.get(AppState.id),
                        listName: try row.get(AppState.listName))
            })
            
            self.lists = allLists

        } catch {
            fatalError("Couldn't initialize db")
        }
    }
    
    func refreshLists() -> Bool {
        do {
            let allListsQuery  = Array(try db.prepare(AppState.listTable))
            let allLists = try allListsQuery.map({ row in
                BigList(id: try row.get(AppState.id),
                        listName: try row.get(AppState.listName))
            })

            self.lists = allLists
            
            return true
        } catch {
            return false
        }
                
    }
    
    func deleteList(listName: String) -> Bool {
        do {
            try db.run(AppState.listTable.filter(AppState.listName == listName).delete())
            return true
        }
        catch {
            return false
        }
    }
    
    func addNewList(listName: String) -> Bool {
        do {
            try db.run(AppState.listTable.insert(AppState.listName <- listName))
            return true
        }
        catch {
            return false
        }
    }
    
    func getListItems(listId: Int64) -> [BigListItem]? {
        do {
            let listItemRows = try db.prepare(AppState.listItemTable.filter(AppState.listId == listId))
            
            return try listItemRows.map({ row in
                BigListItem(id: try row.get(AppState.id),
                            listText: try row.get(AppState.listItemName),
                            listId: try row.get(AppState.listId))
            })
        }
        catch {
            return nil
        }
    }
    
    func addNewListItem(listItemText: String, parentListId: Int64) -> Bool {
        do {
            try db.run(AppState.listItemTable
                        .insert(AppState.listItemName <- listItemText,
                                AppState.listId <- parentListId))
            return true
        } catch {
            return false
        }
    }
    
    func deleteListItem(listItemId: Int64) -> Bool {
        do {
            try db.run(AppState.listItemTable.filter(AppState.id == listItemId).delete())
            return true
        } catch {
            return false
        }
    }
    
    func renameList(listId: Int64, newListName: String) -> Bool {
        do {
            try db.run(AppState.listTable.filter(AppState.id == listId).update(AppState.listName <- newListName))
            return true
        } catch {
            return false
        }
    }
    
    func renameListItem(listItemId: Int64, newListItemText: String) -> Bool {
        do {
            try db.run(AppState.listItemTable.filter(AppState.id == listItemId).update(AppState.listItemName <- newListItemText))
            return true
        } catch {
            return false
        }
    }
}
