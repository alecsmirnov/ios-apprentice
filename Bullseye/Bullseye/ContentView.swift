//
//  ContentView.swift
//  Bullseye
//
//  Created by Admin on 21.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import SwiftUI

private enum Settings {
    static let minimumScore = 1
    static let maximumScore = 100
}

struct ContentView: View {
    // MARK: Properties
    var sliderValueRounded: Int {
        return Int(sliderValue.rounded())
    }
    
    private var difference: Int {
        return abs(target - Int(sliderValue.rounded()))
    }
    
    @State private var alertIsVisble = false
    @State private var sliderValue = 50.0
    @State private var target = ContentView.randomTarget()
    
    @State private var score = 0
    @State private var round = 1
    
    private let midnightBlue = Color(red: 0, green: 0.2, blue: 0.4)
    
    // User interface content and layout
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .navigationBarTitle("🎯 Bullseye 🎯")
                
                // Target row
                HStack {
                    Text("Put the bullseye as close as you can to:")
                        .modifier(LabelStyle())
                    Text("\(target)")
                        .modifier(ValueStyle())
                }
                
                Spacer()
                
                // Slider row
                HStack {
                    Text("\(Settings.minimumScore)")
                        .modifier(LabelStyle())
                    
                    Slider(value: $sliderValue, in: Double(Settings.minimumScore)...Double(Settings.maximumScore))
                        .accentColor(Color.green)
                        .animation(.easeOut)
                    
                    Text("\(Settings.maximumScore)")
                        .modifier(LabelStyle())
                }
                
                Spacer()
                
                // Button row
                Button(action: {
                    self.alertIsVisble = true
                }) {
                    Text("Hit me!")
                        .modifier(ButtonLargeTextStyle())
                }
                .background(Image("Button")
                    .modifier(Shadow())
                )
                .alert(isPresented: $alertIsVisble) {
                    Alert(title: Text(alertTitle()),
                          message: Text(scoringMessage()),
                          dismissButton: .default(Text("Ok"), action: {
                            self.startNewRound()
                    }))
                }
                
                Spacer()
                
                // Score row
                HStack {
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start over")
                                .modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")
                        .modifier(Shadow())
                    )
                    
                    Spacer()
                    
                    Text("Score:")
                        .modifier(LabelStyle())
                    Text("\(score)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    
                    Text("Round:")
                        .modifier(LabelStyle())
                    Text("\(round)")
                        .modifier(ValueStyle())
                    
                    Spacer()
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info")
                                .modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button")
                        .modifier(Shadow())
                    )
                }
                .padding(.leading, 20)
                .padding(.trailing, 40)
                .padding(.bottom, 20)
                .accentColor(midnightBlue)
            }
            .onAppear() {
                self.startNewGame()
            }
            .background(Image("Background"))
            .padding(.all, 20)
        }
    }
    
    // MARK: Methods
    private static func randomTarget() -> Int {
        return Int.random(in: Settings.minimumScore...Settings.maximumScore)
    }
    
    private func resetSliderAndTarget() {
        sliderValue = Double.random(in: Double(Settings.minimumScore)...Double(Settings.maximumScore))
        target = ContentView.randomTarget()
    }
    
    private func startNewGame() {
        score = 0
        round = 1
        
        resetSliderAndTarget()
    }
    
    private func startNewRound() {
        score += pointsForCurrentRound()
        round += 1
        
        resetSliderAndTarget()
    }
    
    private func pointsForCurrentRound() -> Int {
        let points: Int
        
        switch difference {
        case 0:
            points = 200
        case 1:
            points = 150
        default:
            points = Settings.maximumScore - difference
        }
        
        return points
    }
    
    private func alertTitle() -> String {
        let title: String
        
        switch difference {
        case 0:
            title = "Perfect!"
        case let x where x < 5:
            title = "You almost had it!"
        case let x where x <= 10:
            title = "Not bad."
        default:
            title = "Are you even trying?"
        }
        
        return title
    }
    
    private func scoringMessage() -> String {
        return "The slider value is: \(sliderValueRounded).\n" +
               "The target value is: \(target).\n" +
               "You scored \(pointsForCurrentRound()) points this round!"
    }
}

// MARK: - ViewModifier
struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial", size: 18))
            .foregroundColor(Color.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial", size: 12))
            .foregroundColor(Color.black)
    }
}

// MARK: - PreviewProvider
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
