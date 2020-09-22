//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Admin on 22.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation

struct ChecklistItem: Identifiable {
    let id = UUID()
    
    var name: String
    var isChecked = false
}
