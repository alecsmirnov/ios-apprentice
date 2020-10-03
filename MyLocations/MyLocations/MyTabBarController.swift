//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Admin on 03.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // TabBarController will look at its own preferredStatusBarStyle property instead of other view controllers
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
