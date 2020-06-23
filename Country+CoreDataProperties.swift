//
//  Country+CoreDataProperties.swift
//  CoreDataRelationship
//
//  Created by Shawn Li on 6/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?
    @NSManaged public var issue: Passport?

}
