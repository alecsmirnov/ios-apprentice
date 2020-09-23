//
//  NewChecklistItemView.swift
//  Checklist
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct NewChecklistItemView: View {
    var checklist: Checklist
    
    @State private var newItemName = ""
    
    // Access to system-wide settings
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Text("Add new item")
            Form {
                TextField("Enter new item name here", text: $newItemName)
                Button(action: {
                    let newChecklistItem = ChecklistItem(name: self.newItemName)
                    self.checklist.items.append(newChecklistItem)
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add new item")
                    }
                }
                .disabled(newItemName.isEmpty)
            }
            Text("Swipe down to cancel.")
        }
    }
}

#if DEBUG
struct NewChecklistItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewChecklistItemView(checklist: Checklist())
    }
}
#endif
