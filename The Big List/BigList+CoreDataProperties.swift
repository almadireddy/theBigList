//
//  BigList+CoreDataProperties.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/11/20.
//
//

import Foundation
import CoreData


extension BigList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigList> {
        return NSFetchRequest<BigList>(entityName: "BigList")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var listName: String?
    @NSManaged public var listItems: NSOrderedSet?
    
    public var safeListName : String {
        return listName ?? "unknown"
    }
    
    public var listItemArray : [BigListItem] {
        var  s = listItems?.array as? [BigListItem] ?? []
        s = s.sorted(by: {
            $0.safeDueDate.compare($1.safeDueDate) == .orderedAscending
        })
        return s
    }
}


// MARK: Generated accessors for listItems
extension BigList {

    @objc(insertObject:inListItemsAtIndex:)
    @NSManaged public func insertIntoListItems(_ value: BigListItem, at idx: Int)

    @objc(removeObjectFromListItemsAtIndex:)
    @NSManaged public func removeFromListItems(at idx: Int)

    @objc(insertListItems:atIndexes:)
    @NSManaged public func insertIntoListItems(_ values: [BigListItem], at indexes: NSIndexSet)

    @objc(removeListItemsAtIndexes:)
    @NSManaged public func removeFromListItems(at indexes: NSIndexSet)

    @objc(replaceObjectInListItemsAtIndex:withObject:)
    @NSManaged public func replaceListItems(at idx: Int, with value: BigListItem)

    @objc(replaceListItemsAtIndexes:withListItems:)
    @NSManaged public func replaceListItems(at indexes: NSIndexSet, with values: [BigListItem])

    @objc(addListItemsObject:)
    @NSManaged public func addToListItems(_ value: BigListItem)

    @objc(removeListItemsObject:)
    @NSManaged public func removeFromListItems(_ value: BigListItem)

    @objc(addListItems:)
    @NSManaged public func addToListItems(_ values: NSOrderedSet)

    @objc(removeListItems:)
    @NSManaged public func removeFromListItems(_ values: NSOrderedSet)

}
