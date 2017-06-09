//
//  FerryClass+CoreDataProperties.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/25/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData


extension FerryClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FerryClass> {
        return NSFetchRequest<FerryClass>(entityName: "FerryClass")
    }

    @NSManaged public var ferryClassName: String?
    @NSManaged public var classID: String?
    @NSManaged public var silhouetteImgURL: String?
    @NSManaged public var drawingImgURL: String?
    @NSManaged public var vessels: NSSet?

}

// MARK: Generated accessors for vessels
extension FerryClass {

    @objc(addVesselsObject:)
    @NSManaged public func addToVessels(_ value: Vessel)

    @objc(removeVesselsObject:)
    @NSManaged public func removeFromVessels(_ value: Vessel)

    @objc(addVessels:)
    @NSManaged public func addToVessels(_ values: NSSet)

    @objc(removeVessels:)
    @NSManaged public func removeFromVessels(_ values: NSSet)

}
