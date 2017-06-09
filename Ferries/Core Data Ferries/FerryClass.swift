//
//  FerryClass.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/24/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import Foundation
import CoreData

extension FerryClass {
    
    
    class func ferryClassWithDictionary(_ moc: NSManagedObjectContext,
                                        dictionary: [String: Any]) -> FerryClass? {
//        print(#function, dictionary)
//        for (key, value) in dictionary {
//            print (key, value)
//        }
        if let classID = dictionary["ClassID"] {
            let classIDString = "\(classID)"
            if let ferryClass = fetchFerryClassWithClassID(moc, classID: classIDString) {
                return ferryClass
            }
            else {
                let ferryClass = FerryClass(context: moc)
                ferryClass.classID = classIDString
                if let ferryClassName = dictionary["ClassName"] {
                    ferryClass.ferryClassName = "\(ferryClassName)"
                }
                if let silhouetteImgURL = dictionary["SilhouetteImg"] {
                    ferryClass.silhouetteImgURL = "\(silhouetteImgURL)"
                }
                if let drawingImgURL = dictionary["DrawingImg"] {
                    ferryClass.drawingImgURL = "\(drawingImgURL)"
                }
                return ferryClass
            }
        }
        return nil
    }
    
    class func fetchFerryClassWithClassID(_ moc: NSManagedObjectContext,
                                          classID: String) -> FerryClass? {
        let model = moc.persistentStoreCoordinator?.managedObjectModel
        if let request = model?.fetchRequestFromTemplate(withName: "ferryClassWithClassID",
                                                         substitutionVariables: ["requestedID": classID]) {
            do {
                let fetchResult = try moc.fetch(request)
                if fetchResult.count > 0 {
                    return fetchResult[0] as? FerryClass
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
    
}
