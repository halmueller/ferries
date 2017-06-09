//
//  FerriesMapController.swift
//  Ferries In Class
//
//  Created by Hal Mueller on 5/25/17.
//  Copyright © 2017 Hal Mueller. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class FerriesMapController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = FerriesCoreDataStack.shared.persistentContainer.viewContext
    var vesselAnnotationsDictionary: [String: VesselAnnotation] = [:]
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.region = MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: 48.0, longitude: -122.5),
                                                       span: MKCoordinateSpan.init(latitudeDelta: 1.6, longitudeDelta: 0.8))

        if let vessels = fetchedResultsController.fetchedObjects {
            for vessel in vessels {
                let annotation = VesselAnnotation.annotation(vessel: vessel)
                vesselAnnotationsDictionary[vessel.vesselID!] = annotation
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Vessel> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Vessel> = Vessel.fetchRequest()

        let timestampDescriptor = NSSortDescriptor(key: "positionUpdateTime", ascending: false)
        fetchRequest.sortDescriptors = [timestampDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: self.managedObjectContext!,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Vessel>? = nil
    
    // MARK: - NSFRC Delegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let vessel = anObject as? Vessel {
            switch type {
            case .insert:
                print("inserted", vessel.name ?? "")
                let annotation = VesselAnnotation.annotation(vessel: vessel)
                vesselAnnotationsDictionary[vessel.vesselID!] = annotation
                mapView.addAnnotation(annotation)
            case .delete:
                if let annotation = vesselAnnotationsDictionary[vessel.vesselID!] {
                    print("deleted", vessel.name ?? "")
                    mapView.removeAnnotation(annotation)
                }
            case .update:
                print("updated", vessel.name ?? "")
                if let annotation = vesselAnnotationsDictionary[vessel.vesselID!] {
                    annotation.update(vessel: vessel)
                }
            case .move:
                print("moved", vessel.name ?? "")
                if let annotation = vesselAnnotationsDictionary[vessel.vesselID!] {
                    annotation.update(vessel: vessel)
                }
            }
        }
    }
    
}
