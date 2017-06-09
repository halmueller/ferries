//
//  PositionReport+CoreDataProperties.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/30/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData


extension PositionReport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PositionReport> {
        return NSFetchRequest<PositionReport>(entityName: "PositionReport")
    }

    @NSManaged public var heading: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var vessel: Vessel?

}
