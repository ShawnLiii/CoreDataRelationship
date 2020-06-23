//
//  User+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Shawn Li on 6/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var secondName: String?
    @NSManaged public var userId: Int64
    @NSManaged public var passport: Passport?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension User {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}
