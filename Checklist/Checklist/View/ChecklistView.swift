//
//  ChecklistView.swift
//  Checklist
//
//  Created by Admin on 22.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct ChecklistView: View {
    @ObservedObject var checklist = Checklist()
    
    @State var newChecklistItemViewIsVisible = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(checklist.items) { index in
                    RowView(checklistItem: self.$checklist.items[index])
                }
                .onDelete(perform: checklist.deleteListItem)
                .onMove(perform: checklist.moveListItem)
            }
            .navigationBarTitle("Checklist", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.newChecklistItemViewIsVisible = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add item")
                    }
                },
                trailing: EditButton()
            )
            .sheet(isPresented: $newChecklistItemViewIsVisible) {
                NewChecklistItemView(checklist: self.checklist)
            }
        }
        .onAppear() {
            self.checklist.saveListItems()
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
#endif
