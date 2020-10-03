//
//  LocationCell.swift
//  MyLocations
//
//  Created by Admin on 01.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selection = UIView(frame: CGRect.zero)
        selection.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        
        selectedBackgroundView = selection
        
        // Rounded corners for images
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        // Makes sure that the image view respects these rounded corners and does not draw outside them
        photoImageView.clipsToBounds = true
        
        // Moves the separator lines between the cells to the right
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
    }
    
    // MARK: - Helper Method
    
    func configure(for location: Location) {
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = location.locationDescription
        }
        
        if let placemark = location.placemark {
            var text = ""
            text.add(text: placemark.subThoroughfare)
            text.add(text: placemark.thoroughfare, separatedBy: " ")
            text.add(text: placemark.locality, separatedBy: ", ")
            
            addressLabel.text = text
        } else {
            addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", location.latitude, location.longitude)
        }
        
        photoImageView.image = thumbnail(for: location)
    }
    
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resized(withBounds: CGSize(width: 52, height: 52))
        }
        
        return UIImage(named: "No Photo")!
    }
}
