//
//  AboutViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 24.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHtml()
    }
    
    private func loadHtml() {
        if let url = Bundle.main.url(forResource: "Bullseye", withExtension: "html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction private func close() {
        dismiss(animated: true, completion: nil)
    }
}
