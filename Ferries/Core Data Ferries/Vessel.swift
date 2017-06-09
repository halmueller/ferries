//
//  Vessel.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/24/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData

extension Vessel {
    class func fetch(vesselID: String,
                     context: NSManagedObjectContext) -> Vessel? {
        let model = context.persistentStoreCoordinator?.managedObjectModel
        if let request = model?.fetchRequestFromTemplate(withName: "vesselsWithVesselID", substitutionVariables: ["requestedID": vesselID]) {
            do {
                let fetchResult = try context.fetch(request)
                if fetchResult.count > 0 {
                    return fetchResult[0] as? Vessel
                }
                else {
                    return nil
                }
            }
            catch {
                print ("fetch", request, "failed", error)
                abort()
            }
        }
        return nil
    }
    
    class func fetchVesselWithVesselID(_ moc: NSManagedObjectContext,
                                       vesselID: String) -> Vessel? {
        let model = moc.persistentStoreCoordinator?.managedObjectModel
        if let request = model?.fetchRequestFromTemplate(withName: "vesselsWithVesselID", substitutionVariables: ["requestedID": vesselID]) {
            do {
                let fetchResult = try moc.fetch(request)
                if fetchResult.count > 0 {
                    return fetchResult[0] as? Vessel
                }
                else {
                    return nil
                }
            }
            catch {
                print ("fetch", request, "failed", error)
                abort()
            }
        }
        return nil
    }
    
    class func findOrCreateVesselWithVesselID(_ moc: NSManagedObjectContext,
                                        vesselID: String,
                                        vesselName: String,
                                        abbreviatedName: String) -> Vessel? {
        if let result = fetchVesselWithVesselID(moc, vesselID: vesselID) {
            return result
        }
        let newResult = Vessel(context: moc)
        newResult.vesselID = vesselID
        newResult.abbreviatedName = abbreviatedName
        newResult.name = vesselName
        
        // also:
        // find or create FerryClass
        // find or create VesselDetail
        
        return newResult
    }
    
    func updateLatestPosition(_ positionReport: PositionReport) {
        latitude = positionReport.latitude
        longitude = positionReport.longitude
        positionUpdateTime = positionReport.timestamp
    }
}

