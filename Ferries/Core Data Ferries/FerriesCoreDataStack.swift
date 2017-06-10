//
//  FerriesCoreDataStack.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/17/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation

import CoreData

import AVFoundation

class FerriesCoreDataStack {
    lazy var speechSynthesizer = {
        return AVSpeechSynthesizer()
    }()
    
    var shouldAnnounce = true
    
    func announce(_ string: String) {
        if shouldAnnounce {
            let utterance = AVSpeechUtterance.init(string: string)
            speechSynthesizer.speak(utterance)
        }
    }
    
    func beginContinuousUpdates() {
        announce("\(#function) line \(#line). Starting continuous updates")
        networkUpdatesTimer = Timer.scheduledTimer(withTimeInterval: 8.0,
                                                   repeats: true,
                                                   block: { (timer) in
                                                    self.updatePositionsData()
        })
    }
    
    func endContinuousUpdates() {
        announce("ending continuous updates")
        networkUpdatesTimer?.invalidate()
        networkUpdatesTimer = nil
    }
    
    static let shared = FerriesCoreDataStack()
    
    var networkUpdatesTimer: Timer?
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Ferries")
        debugPrint("open ", NSPersistentContainer.defaultDirectoryURL())
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // TODO: You can get an access code from Washington State DOT at https://www.wsdot.wa.gov/traffic/api/
    // The one below won't work.
    let accessCode = // "xyzzyxyz-zyxy-zzyx-yzzy-xyzzyxyzzyxy"
    
    func updatePositionsData () {
        announce("positions update")
        
        let defaultConfiguration = URLSessionConfiguration.default
        
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        
        if let vesselLocationsURL = URL(string: "http://www.wsdot.wa.gov/ferries/api/vessels/rest/vessellocations?apiaccesscode=\(accessCode)") {
            (sessionWithoutADelegate.dataTask(with: vesselLocationsURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    //                    let response = response,
                    //                    let string = String(data: data, encoding: .utf8) {
                    //			print("Locations response: \(response)")
                    //			print("Locations DATA:\n\(string)\nEND Locations DATA\n")
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:AnyObject]] {
                            self.persistentContainer.performBackgroundTask{ privateContext in
                                for positionReportEntry in jsonResult {
                                    if let vesselID = positionReportEntry["VesselID"],
                                        let latitude = positionReportEntry["Latitude"],
                                        let longitude = positionReportEntry["Longitude"],
                                        let speed = positionReportEntry["Speed"],
                                        let heading = positionReportEntry["Heading"],
                                        let dateString = positionReportEntry["TimeStamp"] as? String {
                                        if let timestamp = Date(jsonDate: dateString) {
                                            let positionReport = PositionReport.findOrCreatePositionReport(privateContext,
                                                                                                           vesselID: "\(vesselID)",
                                                timestamp: timestamp,
                                                latitude: latitude.doubleValue,
                                                longitude: longitude.doubleValue,
                                                heading: heading.doubleValue,
                                                speed: speed.doubleValue)
                                        }
                                    }
                                }
                                do {
                                    try privateContext.save()
                                }
                                catch {
                                    print(#function, "private context save failed", error.localizedDescription)
                                    abort()
                                }
                            }
                        }
                    }
                    catch {
                        print("JSON serialization failed")
                    }
                }
            }).resume()
        }
        
    }
    func updateFerriesData () {
        announce("fleet update")
        let defaultConfiguration = URLSessionConfiguration.default
        
        let sessionWithoutADelegate = URLSession(configuration: defaultConfiguration)
        
        if let vesselBasicsURL = URL(string: "http://www.wsdot.wa.gov/ferries/api/vessels/rest/vesselbasics?apiaccesscode=\(accessCode)") {
            (sessionWithoutADelegate.dataTask(with: vesselBasicsURL) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String:Any]] {
                            self.persistentContainer.performBackgroundTask{ privateContext in
                                for vesselEntry in jsonResult {
                                    //                    print (vesselEntry)
                                    if let name = vesselEntry["VesselName"] as? String,
                                        let vesselID = vesselEntry["VesselID"],
                                        let vesselAbbrevName = vesselEntry["VesselAbbrev"] as? String {
                                        
                                        let vessel = Vessel.findOrCreateVesselWithVesselID(privateContext,
                                                                                           vesselID: "\(vesselID)",
                                            vesselName: name,
                                            abbreviatedName: vesselAbbrevName)
                                        if let vesselClassDictionary = vesselEntry["Class"] as? [String: Any] {
                                            let vesselClass = FerryClass.ferryClassWithDictionary(privateContext,
                                                                                                  dictionary: vesselClassDictionary)
                                            vessel?.ferryClass = vesselClass
                                            
                                        }
                                        // vessel?.ferryClass = < the thing we found >
                                    }
                                    do {
                                        try privateContext.save()
                                    }
                                    catch {
                                        print(#function, "private context save failed", error.localizedDescription)
                                        abort()
                                    }
                                }
                            }
                        }
                    }
                    catch {
                        print("JSON serialization failed")
                    }
                }
                
            }).resume()
        }
        
        
    }
    
    func createSampleData () {
        // invoked via Button on main thread
        
        // let superClass = FerryClass.findOrCreate("super")
        let yakima = Vessel.findOrCreateVesselWithVesselID(persistentContainer.viewContext,
                                                           vesselID: "38",
                                                           vesselName: "Yakima",
                                                           abbreviatedName: "YAK")
        // yakima.ferryClass = superClass
        // let yakimaDetail = FerryDetail( <some stuff> )
        // yakima.detail = yakimaDetail
        
        let spokane = Vessel.findOrCreateVesselWithVesselID(persistentContainer.viewContext,
                                                            vesselID: "30",
                                                            vesselName: "Spokane",
                                                            abbreviatedName: "SPO")
        
        let posit11 = PositionReport(context: self.persistentContainer.viewContext)
        posit11.latitude = 48.0
        posit11.longitude = -122.0
        posit11.vessel = yakima
        posit11.timestamp = Date()
        
        let posit12 = PositionReport(context: self.persistentContainer.viewContext)
        posit12.latitude = 48.01
        posit12.longitude = -122.0
        posit12.vessel = yakima
        posit12.timestamp = Date().addingTimeInterval(-10)
        
        let posit13 = PositionReport(context: self.persistentContainer.viewContext)
        posit13.latitude = 48.02
        posit13.longitude = -122.0
        posit13.vessel = yakima
        posit13.timestamp = Date().addingTimeInterval(-20)
        
        let posit01 = PositionReport(context: self.persistentContainer.viewContext)
        posit01.latitude = 48.0
        posit01.longitude = -122.1
        posit01.vessel = spokane
        posit01.timestamp = Date()
        
        let posit02 = PositionReport(context: self.persistentContainer.viewContext)
        posit02.latitude = 48.01
        posit02.longitude = -122.1
        posit02.vessel = spokane
        posit02.timestamp = Date().addingTimeInterval(-10)
        
        let posit03 = PositionReport(context: self.persistentContainer.viewContext)
        posit03.latitude = 48.02
        posit03.longitude = -122.1
        posit03.vessel = spokane
        posit03.timestamp = Date().addingTimeInterval(-20)
        
        try! self.persistentContainer.viewContext.save()
    }
    
    
}

// from https://stackoverflow.com/questions/33165939/how-to-convert-date-like-date1440156888750-0700-to-something-that-swift-ca/33166980#33166980
// note that the timezone offset in the JSON string must be ignored
extension Date {
    init?(jsonDate: String) {
        
        let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
        let regex = try! NSRegularExpression(pattern: pattern)
        guard let match = regex.firstMatch(in: jsonDate, range: NSRange(location: 0, length: jsonDate.utf16.count)) else {
            return nil
        }
        
        // Extract milliseconds:
        let dateString = (jsonDate as NSString).substring(with: match.rangeAt(1))
        // Convert to UNIX timestamp in seconds:
        let timeStamp = Double(dateString)! / 1000.0
        // Create Date from timestamp:
        self.init(timeIntervalSince1970: timeStamp)
    }
}

