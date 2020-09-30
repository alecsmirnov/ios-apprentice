//
//  Functions.swift
//  MyLocations
//
//  Created by Admin on 30.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
