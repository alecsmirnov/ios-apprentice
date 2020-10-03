//
//  String+AddText.swift
//  MyLocations
//
//  Created by Admin on 03.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation

extension String {
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            
            self += text
        }
    }
}
