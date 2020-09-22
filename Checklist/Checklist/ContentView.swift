//
//  ContentView.swift
//  Checklist
//
//  Created by Admin on 22.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: Properties
    @State private var checklistItems = [ChecklistItem(name: "Walk the dog"),
                                         ChecklistItem(name: "Brush my teeth"),
                                         ChecklistItem(name: "Learn iOS development", isChecked: true),
                                         ChecklistItem(name: "Soccer practice"),
                                         ChecklistItem(name: "Eat ice cream", isChecked: true),
                                        ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(checklistItems) { item in
                    HStack {
                        Text(item.name)
                        
                        Spacer()
                        
                        Text(item.isChecked ? "✅": "🔲")
                    }
                    .background(Color.white)    // This makes the entire row clickable
                    .onTapGesture {
                        if let matchingIndex = self.checklistItems.firstIndex(where: {
                            $0.id == item.id
                        }) {
                            self.checklistItems[matchingIndex].isChecked.toggle()
                        }
                    }
                }
                .onDelete(perform: deleteListItem)
                .onMove(perform: moveListItem)
            }
            .navigationBarTitle("Checklist")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    // MARK: Methods
    private func deleteListItem(whichElement: IndexSet) {
        checklistItems.remove(atOffsets: whichElement)
    }
    
    private func moveListItem(whichElement: IndexSet, destination: Int) {
        checklistItems.move(fromOffsets: whichElement, toOffset: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
