//
//  RowView.swift
//  Checklist
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct RowView: View {
    @Binding var checklistItem: ChecklistItem
    
    var body: some View {
        NavigationLink(destination: EditChecklistItemView(checklistItem: $checklistItem)) {
            HStack {
               Text(checklistItem.name)
               Spacer()
               Text(checklistItem.isChecked ? "✅": "🔲")
            }
        }
    }
}

#if DEBUG
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(checklistItem: .constant(ChecklistItem(name: "Sample item")))
    }
}
#endif
