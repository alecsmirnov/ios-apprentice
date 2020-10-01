//
//  MapViewController.swift
//  MyLocations
//
//  Created by Admin on 01.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                                   object: managedObjectContext,
                                                   queue: OperationQueue.main) { notification in
                if self.isViewLoaded {
                    // userInfo dictionary
                    if let dictionary = notification.userInfo {
                        /*
                        print(dictionary[NSInsertedObjectsKey])
                        print(dictionary[NSUpdatedObjectsKey])
                        print(dictionary[NSDeletedObjectsKey])
                        */
                        
                        if let insertSet = dictionary[NSInsertedObjectsKey] as? Set<Location> {
                            self.insert(location: insertSet.first! as Location)
                        }

                        if let updateSet = dictionary[NSUpdatedObjectsKey] as? Set<Location> {
                            self.update(location: updateSet.first! as Location)
                        }

                        if let deleteSet = dictionary[NSDeletedObjectsKey] as? Set<Location> {
                            self.delete(location: deleteSet.first! as Location)
                        }
                    }
                } else {
                    // Not used, but just in case
                    self.updateLocations()
                }
            }
        }
    }
    
    var locations = [Location]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    // MARK: - Helper methods
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let fetchRequest: NSFetchRequest = Location.fetchRequest()
        locations = try! managedObjectContext.fetch(fetchRequest)
        
        mapView.addAnnotations(locations)
    }
    
    func insert(location: Location) {
        mapView.addAnnotation(location)
    }
    
    func update(location: Location) {
        mapView.removeAnnotation(location)
        mapView.addAnnotation(location)
    }
    
    func delete(location: Location) {
        mapView.removeAnnotation(location)
    }
    
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        latitudinalMeters: 1000, longitudinalMeters: 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 1000, longitudinalMeters: 1000)
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
                
                bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                                                longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace,
                                        longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let controller = segue.destination as! LocationDetailsTableViewController
            controller.managedObjectContext = managedObjectContext
            
            let button = sender as! UIButton
            let location = locations[button.tag]
            
            controller.locationToEdit = location
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showUser() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        latitudinalMeters: 1000,longitudinalMeters: 1000)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        let locationsRegion = region(for: locations)
        
        mapView.setRegion(mapView.regionThatFits(locationsRegion), animated: true)
    }
    
    @objc func showLocationDetails(_ sender: UIButton) {
        // Perform the segue manually
        performSegue(withIdentifier: "EditLocation", sender: sender)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Avoid user location annotation and others
        guard annotation is Location else { return nil }
        
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        // If mapView cannot find a recyclable annotation view, then create a new one
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // Pin configure
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails(_:)), for: .touchUpInside)
            
            pinView.rightCalloutAccessoryView = rightButton
            annotationView = pinView
        }
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            
            // Obtain a reference to detail disclosure button again
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            
            // Set button tag to the index of the Location object in the locations array
            // That way, we can find the Location object later in showLocationDetails() when the button is pressed
            if let index = locations.firstIndex(of: annotation as! Location) {
                button.tag = index
            }
        }
        
        return annotationView
    }
}
