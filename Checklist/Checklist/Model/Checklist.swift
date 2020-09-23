//
//  Checklist.swift
//  Checklist
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import Foundation

class Checklist: ObservableObject {
    @Published var items: [ChecklistItem] = []
    
    init() {
        loadListItems()
    }
    
    func deleteListItem(whichElement: IndexSet) {
        items.remove(atOffsets: whichElement)
        
        saveListItems()
    }
    
    func moveListItem(whichElement: IndexSet, destination: Int) {
        items.move(fromOffsets: whichElement, toOffset: destination)
        
        saveListItems()
    }
    
    func saveListItems() {
        let encoder = PropertyListEncoder()
            
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadListItems() {
        let path = dataFilePath()

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
}
