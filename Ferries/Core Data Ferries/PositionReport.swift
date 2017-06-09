//
//  PositionReport.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/30/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData

extension PositionReport {

    class func findOrCreatePositionReport(_ moc: NSManagedObjectContext,
                                          vesselID: String,
                                          timestamp: Date,
                                          latitude: Double,
                                          longitude: Double,
                                          heading: Double,
                                          speed: Double) -> PositionReport? {
        let model = moc.persistentStoreCoordinator?.managedObjectModel
        if let request = model?.fetchRequestFromTemplate(withName: "positionReportsWithVesselIDAndTimestamp", substitutionVariables: ["vesselID": vesselID, "timestamp": timestamp]) {
        do {
            let fetchResult = try moc.fetch(request)
            if fetchResult.count > 0 {
                return fetchResult[0] as? PositionReport
            }
            else {
                let insertedReport = PositionReport(context: moc)
                insertedReport.timestamp = timestamp
                insertedReport.latitude = latitude
                insertedReport.longitude = longitude
                insertedReport.heading = heading
                insertedReport.speed = speed
                insertedReport.vessel = Vessel.fetchVesselWithVesselID(moc, vesselID: vesselID)
                insertedReport.vessel?.updateLatestPosition(insertedReport)
                return insertedReport
            }
        }
        catch {
            print ("fetch", request, "failed", error)
            abort()
            }
        }
        return nil
    }
    
}
