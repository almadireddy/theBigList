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
   
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            
            db = try Connection("\(path)/appDb.sqlite3")
            
            // list : | id | list_name |
            let lists = Table("lists")
            let id = Expression<Int64>("id")
            let listName = Expression<String>("list_name")

            // list_items : | id | list_name_name | list_id |
            let listItems = Table("list_items")
            let listItemName = Expression<String>("list_item_name")
            let listId = Expression<Int64>("list_id")
            
            // tags : | tag_name |
            let tags = Table("tags")
            let tagName = Expression<String>("tag_name")
            
            // tag_list : | tag_name | list_id |
            let tagList = Table("tag_lists")
            
            try db.run(lists.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(listName, unique: true)
            })
            
            try db.run(listItems.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(listItemName)
                t.column(listId, references: lists, id)
            })
            
            try db.run(tags.create(ifNotExists: true) { t in
                t.column(tagName, primaryKey: true)
            })
            
            try db.run(tagList.create(ifNotExists: true) {t in
                t.column(tagName, primaryKey: true)
                t.column(listId, references: lists, listId)
            })
            
            let allListsQuery  = Array(try db.prepare(Table("lists")))
            let allLists = try allListsQuery.map({ row in
                BigList(id: try row.get(Expression<Int64>("id")),
                        listName: try row.get(Expression<String>("list_name")))
            })
            
            self.lists = allLists

        } catch {
            fatalError("Couldn't initialize db")
        }
    }
    
    func refreshLists() -> Bool {
        do {
            let allListsQuery  = Array(try db.prepare(Table("lists")))
            let allLists = try allListsQuery.map({ row in
                BigList(id: try row.get(Expression<Int64>("id")),
                        listName: try row.get(Expression<String>("list_name")))
            })

            self.lists = allLists
            
            return true
        } catch {
            return false
        }
                
    }
    
    func deleteList(listName: String) -> Bool {
        do {
            try db.run(Table("lists").filter(Expression<String>("list_name") == listName).delete())
            return true
        }
        catch {
            return false
        }
    }
    
    func addNewList(listName: String) -> Bool {
        do {
            try db.run(Table("lists").insert(Expression<String>("list_name") <- listName))
            return true
        }
        catch {
            return false
        }
    }
    
    func getListItems(listId: Int64) -> [BigListItem]? {
        do {
            let listItemRows = try db.prepare(Table("list_items").filter(Expression<Int64>("list_id") == listId))
            
            return try listItemRows.map({ row in
                BigListItem(id: try row.get(Expression<Int64>("id")),
                            listText: try row.get(Expression<String>("list_item_name")),
                            listId: try row.get(Expression<Int64>("list_id")))
            })
        }
        catch {
            return nil
        }
    }
    
    func addNewListItem(listItemText: String, parentListId: Int64) -> Bool {
        do {
            try db.run(Table("list_items")
                        .insert(Expression<String>("list_item_name") <- listItemText,
                                Expression<Int64>("list_id") <- parentListId))
            return true
        } catch {
            return false
        }
    }
    
    func deleteListItem(listItemId: Int64) -> Bool {
        do {
            try db.run(Table("list_items").filter(Expression<Int64>("id") == listItemId).delete())
            return true
        } catch {
            return false
        }
    }
}
