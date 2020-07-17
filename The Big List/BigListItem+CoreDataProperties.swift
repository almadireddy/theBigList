//
//  BigListItem+CoreDataProperties.swift
//  The Big List
//
//  Created by Aahlad Madireddy on 7/11/20.
//
//

import Foundation
import CoreData


extension BigListItem : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigListItem> {
        return NSFetchRequest<BigListItem>(entityName: "BigListItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isComplete: Bool
    @NSManaged public var listItemText: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var parentList: BigList?

    public var safeListItemText: String {
        return listItemText ?? "unknown"
    }
    
    public var safeCreatedAt : Date {
        return createdAt ?? Date(timeIntervalSince1970: 0)
    }
    
    public var safeDueDate : Date {
        return dueDate ?? Date(timeInterval: 0, since: safeCreatedAt)
    }
}
