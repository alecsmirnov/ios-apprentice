//
//  AboutView.swift
//  Bullseye
//
//  Created by Admin on 22.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    private let beige = Color(red: 1, green: 0.84, blue: 0.7)
    
    var body: some View {
        Group {
            VStack {
                Text("🎯 Bullseye 🎯")
                    .modifier(AboutHeadingStyle())
                    .navigationBarTitle("About Bullseye")
                
                Text("This is Bullseye, the game where you can win points and earn fame by dragging a slider.")
                    .lineLimit(nil)
                    .modifier(AboutBodyStyle())
                
                Text("Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score.")
                    .lineLimit(nil)
                    .modifier(AboutBodyStyle())
                
                Text("Enjoy!")
                    .modifier(AboutBodyStyle())
            }
            .background(beige)
        }
        .background(Image("Background"))
    }
}

// MARK: - ViewModifier
struct AboutHeadingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial", size: 30))
            .foregroundColor(Color.black)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}
struct AboutBodyStyle: ViewModifier {
    func body(content: Content) -> some View {
    content
        .font(Font.custom("Arial", size: 16))
        .foregroundColor(Color.black)
        .padding(.leading, 60)
        .padding(.trailing, 60)
        .padding(.bottom, 20)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
