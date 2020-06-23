//
//  Task+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Shawn Li on 6/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var details: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var ofUser: User?

}
