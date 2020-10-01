//
//  Location+MKAnnotation.swift
//  MyLocations
//
//  Created by Admin on 01.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation
import MapKit

extension Location: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    
    public var subtitle: String? {
        return category
    }
}
