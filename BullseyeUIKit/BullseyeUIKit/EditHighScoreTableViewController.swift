//
//  EditHighScoreTableViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 26.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class EditHighScoreTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func cancel() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    @IBAction private func done() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
