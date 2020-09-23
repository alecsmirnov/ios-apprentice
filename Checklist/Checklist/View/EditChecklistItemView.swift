//
//  EditChecklistItemView.swift
//  Checklist
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct EditChecklistItemView: View {
    @Binding var checklistItem: ChecklistItem
    
    var body: some View {
        Form {
            TextField("Name", text: $checklistItem.name)
            Toggle("Completed", isOn: $checklistItem.isChecked)
        }
    }
}

#if DEBUG
struct EditChecklistItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditChecklistItemView(checklistItem: .constant(ChecklistItem(name: "Sample item")))
    }
}
#endif
