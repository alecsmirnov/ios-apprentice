//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Admin on 04.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20 / 255, green: 160 / 255, blue: 160 / 255, alpha: 0.5)
        
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    // MARK: - Public Methods
    
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        }
        
        artworkImageView.image = UIImage(named: "Placeholder")
        
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }
}
