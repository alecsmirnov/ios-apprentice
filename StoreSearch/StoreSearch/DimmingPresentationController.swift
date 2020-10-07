//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Admin on 07.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    // Leave the SearchViewController visible
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
