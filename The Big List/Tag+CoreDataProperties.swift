//
//  Tag+CoreDataProperties.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/19/20.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var tagName: String?
    @NSManaged public var listItems: NSSet?
    @NSManaged public var lists: NSSet?
    
    public var safeColor : String {
        return self.color ?? "green"
    }
    
    public var safeTagName : String {
        return self.tagName ?? "unknown"
    }
    
    public var listArray : [BigList] {
        return lists?.allObjects as? [BigList] ?? []
    }
}

// MARK: Generated accessors for listItems
extension Tag {

    @objc(addListItemsObject:)
    @NSManaged public func addToListItems(_ value: BigListItem)

    @objc(removeListItemsObject:)
    @NSManaged public func removeFromListItems(_ value: BigListItem)

    @objc(addListItems:)
    @NSManaged public func addToListItems(_ values: NSSet)

    @objc(removeListItems:)
    @NSManaged public func removeFromListItems(_ values: NSSet)

}

// MARK: Generated accessors for lists
extension Tag {

    @objc(addListsObject:)
    @NSManaged public func addToLists(_ value: BigList)

    @objc(removeListsObject:)
    @NSManaged public func removeFromLists(_ value: BigList)

    @objc(addLists:)
    @NSManaged public func addToLists(_ values: NSSet)

    @objc(removeLists:)
    @NSManaged public func removeFromLists(_ values: NSSet)

}
