//
//  ContentView.swift
//  Bullseye
//
//  Created by Admin on 21.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: Properties
    @State private var alertIsVisble: Bool = false
    @State private var sliderValue: Double = 50
    
    // User interface content and layout
    var body: some View {
        VStack {
            Spacer()
            
            // Target row
            HStack {
                Text("Put the bullseye as close as you can to:")
                Text("\(Int(sliderValue.rounded()))")
            }
            
            Spacer()
            
            // Slider row
            HStack {
                Text("1")
                Slider(value: $sliderValue, in: 1...100)
                Text("100")
            }
            
            Spacer()
            
            // Button row
            Button(action: {
                self.alertIsVisble = true
            }) {
                Text(/*@START_MENU_TOKEN@*/"Hit me"/*@END_MENU_TOKEN@*/)
            }
            .alert(isPresented: $alertIsVisble) { () -> Alert in
                Alert(title: Text("Hello"), message: Text("This is pop-up"), dismissButton: .default(Text("Ok")))
            }
            
            Spacer()
            
            // Score row
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text(/*@START_MENU_TOKEN@*/"Start over"/*@END_MENU_TOKEN@*/)
                }
                
                Spacer()
                
                Text(/*@START_MENU_TOKEN@*/"Score:"/*@END_MENU_TOKEN@*/)
                Text(/*@START_MENU_TOKEN@*/"999999"/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Text("Round:")
                Text("999")
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Info")
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.all, 20)
    }
    
    // MARK: Methods
}

// MARK: - Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
