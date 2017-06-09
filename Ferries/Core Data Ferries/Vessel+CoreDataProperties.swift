//
//  Vessel+CoreDataProperties.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/17/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData


extension Vessel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vessel> {
        return NSFetchRequest<Vessel>(entityName: "Vessel")
    }

    @NSManaged public var name: String?
    @NSManaged public var abbreviatedName: String?
    @NSManaged public var vesselID: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var positionUpdateTime: Date?
    @NSManaged public var detail: Detail?
    @NSManaged public var positionReports: NSSet?
    @NSManaged public var ferryClass: FerryClass?

}

// MARK: Generated accessors for positionReports
extension Vessel {

    @objc(addPositionReportsObject:)
    @NSManaged public func addToPositionReports(_ value: PositionReport)

    @objc(removePositionReportsObject:)
    @NSManaged public func removeFromPositionReports(_ value: PositionReport)

    @objc(addPositionReports:)
    @NSManaged public func addToPositionReports(_ values: NSSet)

    @objc(removePositionReports:)
    @NSManaged public func removeFromPositionReports(_ values: NSSet)

}
