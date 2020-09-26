//
//  HighScoreItem.swift
//  BullseyeUIKit
//
//  Created by Admin on 26.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation

// NSObject is an alternative to Equatable, without the need to specify a way to compare two objects
class HighScoreItem: NSObject, Codable {
    var name = ""
    var score = 0
}
