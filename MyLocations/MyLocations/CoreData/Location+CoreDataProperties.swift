//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Admin on 30.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//
//

import Foundation
import CoreLocation
import CoreData

extension Location {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date
    @NSManaged public var locationDescription: String
    @NSManaged public var category: String
    //@NSManaged public var placemark: NSObject?
    // CLPPlacemark supports NSCoding protocol
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var photoID: NSNumber?
}
