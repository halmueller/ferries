//
//  VesselAnnotation.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/31/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class VesselAnnotation: NSObject, MKAnnotation {
    dynamic var title: String? = nil
    dynamic var subtitle: String? = nil
    dynamic var coordinate: CLLocationCoordinate2D
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    init(latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.title = title
        self.subtitle = subtitle
    }
 
    class func annotation(vessel: Vessel) -> VesselAnnotation {
        let result = VesselAnnotation(latitude: vessel.latitude, longitude: vessel.longitude, title: vessel.name, subtitle: "")
        result.update(vessel: vessel)
        return result
    }
    
    func update(vessel: Vessel) {
        coordinate = CLLocationCoordinate2D(latitude: vessel.latitude, longitude: vessel.longitude)
        self.title = vessel.name
        if let positionUpdateTime = vessel.positionUpdateTime {
            self.subtitle = VesselAnnotation.dateFormatter.string(from: positionUpdateTime)
        }
        else {
            self.subtitle = ""
        }
    }
}
