//
//  Passport+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Shawn Li on 6/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//
//

import Foundation
import CoreData


extension Passport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passport> {
        return NSFetchRequest<Passport>(entityName: "Passport")
    }

    @NSManaged public var expireData: Date?
    @NSManaged public var number: String?
    @NSManaged public var ofUser: User?
    @NSManaged public var issueBy: Country?

}
