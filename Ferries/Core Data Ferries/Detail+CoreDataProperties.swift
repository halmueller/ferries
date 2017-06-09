//
//  Detail+CoreDataProperties.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/17/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData


extension Detail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail> {
        return NSFetchRequest<Detail>(entityName: "Detail")
    }

    @NSManaged public var history: String?
    @NSManaged public var nameDescription: String?
    @NSManaged public var lengthFeetInches: String?
    @NSManaged public var drawingURL: String?
    @NSManaged public var vessel: Vessel?

}
