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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.backgroundColor = .red
        //pageControl.backgroundColor = .green
        
        disableAutoLayoutConstraints()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
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
        
        for (index, result) in searchResults.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.white
            button.setTitle("\(index)", for: .normal)
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row) * itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            
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
    }
}
