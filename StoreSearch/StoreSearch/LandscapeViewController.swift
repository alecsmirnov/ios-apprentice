//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Admin on 08.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    var searchResults = [SearchResult]()
    
    private var firstTime = true
    private var downloads = [URLSessionDownloadTask]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableAutoLayoutConstraints()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        pageControl.numberOfPages = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x,
                                   y: safeFrame.size.height - pageControl.frame.size.height,
                                   width: safeFrame.size.width,
                                   height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            tileButtons(searchResults)
        }
    }
    
    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
        }, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func disableAutoLayoutConstraints() {
        // Remove constraints from main view
        view.removeConstraints(view.constraints)
        // Allows to position and size views manually by changing their frame property
        // Convert manual layout code into the proper constraints
        view.translatesAutoresizingMaskIntoConstraints = true
        
        // Remove constraints for page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        
        // Remove constraints for scroll view
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // MARK: - Private Methods
    
    private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) { [weak button] url, response, error in
                if error == nil,
                   let url = url,
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let button = button {
                            button.setImage(image, for: .normal)
                        }
                    }
                }
            }
            
            task.resume()
            
            downloads.append(task)
        }
    }
    
    private func tileButtons(_ searchResults: [SearchResult]) {
        let itemSizeMin: CGFloat = 82
        let itemSizeMax: CGFloat = 92
        
        let viewWidth = scrollView.bounds.size.width
        let viewHeight = scrollView.bounds.size.height - pageControl.bounds.size.height
        
        var columnsPerPage = 0
        var rowsPerPage = 0
        
        var itemWidth: CGFloat = 0
        var itemHeight: CGFloat = 0
        
        for size in stride(from: itemSizeMax, to: itemSizeMin, by: -1) {
            let newColumnsCount = Int(viewWidth / size)
            if columnsPerPage < newColumnsCount {
                columnsPerPage = newColumnsCount
                itemWidth = size
            }
            
            let newRowsCount = Int(viewHeight / size)
            if rowsPerPage < newRowsCount {
                rowsPerPage = newRowsCount
                itemHeight = size
            }
        }
        
        let marginX: CGFloat = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) / 2
        let marginY: CGFloat = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) / 2
        
        // Button size
        let buttonWidth: CGFloat = itemSizeMin
        let buttonHeight: CGFloat = itemSizeMin
        
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2
        
        // Add the buttons
        var row = 0
        var column = 0
        var x = marginX
        
        for (_, result) in searchResults.enumerated() {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
            
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row) * itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            
            downloadImage(for: result, andPlaceOn: button)
            
            scrollView.addSubview(button)
            
            row += 1
            if row == rowsPerPage {
                row = 0
                x += itemWidth
                column += 1
                
                if column == columnsPerPage {
                    column = 0
                    x += marginX * 2
                }
            }
        }
        
        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth, height: scrollView.bounds.size.height)
        print("Number of pages: \(numPages)")
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }
}

// MARK: - UIScrollViewDelegate

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        // contentOffset determines how far the scroll view has been scrolled
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
            
        pageControl.currentPage = page
    }
}
