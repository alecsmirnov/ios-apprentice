//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Admin on 30.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoURL: URL {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let key = "PhotoID"
        let userDefaults = UserDefaults.standard
        
        let nextID = userDefaults.integer(forKey: key) + 1
        userDefaults.set(nextID, forKey: key)
        //userDefaults.synchronize()
        
        return nextID
    }
    
    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            } catch {
                print("Error removing file: \(error)")
            }
        }
    }
}
