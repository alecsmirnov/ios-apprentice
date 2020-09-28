//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Admin on 27.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    var lastLocationError: Error?
    var updatingLocation = false
    
    let geocoder = CLGeocoder()
    
    var placemark: CLPlacemark?
    var lastGeocodingError: Error?
    var performingReverseGeocoding = false
    
    var timer: Timer?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    func updateLabels() {
        if let location = location {
            messageLabel.text = ""
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            
            tagButton.isHidden = false
            
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            
            tagButton.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {    // Check if the location service is disabled on the device
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            messageLabel.text = statusMessage
        }
        
        configureGetButton()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            
            // Location Accuracy
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // Current location request
            locationManager.startUpdatingLocation()
            
            updatingLocation = true
            
            // Sends a didTimeOut message to self after 60 seconds
            timer = Timer.scheduledTimer(timeInterval: 60,
                                         target: self,
                                         selector: #selector(didTimeOut),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        
        if let s = placemark.thoroughfare {
            line1 += s
        }
        
        var line2 = ""
        
        if let s = placemark.locality {
            line2 += s + " "
        }
        
        if let s = placemark.administrativeArea {
            line2 += s + " "
        }
        
        if let s = placemark.postalCode {
            line2 += s
        }
        
        return line1 + "\n" + line2
    }
    
    // MARK: Actions
    
    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            // Receive information about updating the location when the application is active
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            
            startLocationManager()
        }
        
        updateLabels()
    }
    
    // MARK: Helper Methods
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTimeOut() {
        if location == nil {
            stopLocationManager()
            
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            
            updateLabels()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // The location manager was unable to obtain a location right now, but Core Location will keep trying
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        // If the error is more serious than the inability to get the current location
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
    }
    
    // Run location manager to respond to changes geolocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The last location is the most accurate position
        let newLocation = locations.last!
        
        // If the time at which the given location object was determined is too long ago - 5 sec
        let determinationTime = -5.0
        if newLocation.timestamp.timeIntervalSinceNow < determinationTime {
            return
        }
        
        // Ignore accuracy less than zero (invalid)
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        // Larger accuracy value == less accurate
        if location == nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy {
            location = newLocation
            lastLocationError = nil
            
            // Stop receiving new locations
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            
            updateLabels()
            
            if !performingReverseGeocoding {
                performingReverseGeocoding = true
                
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: { [unowned self] (placemarks, error) in
                    self.lastGeocodingError = error
                    
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                })
            }
        } else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            
            if timeInterval > 10 {
                stopLocationManager()
                updateLabels()
            }
        }
    }
}
