//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Spare on 01/07/2020.
//  Copyright © 2020 Spare. All rights reserved.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
        .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    
    @State private var finalScore: Int = 0
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var showingOutOfTime = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var dismissTitle = ""
    @State private var scoreMessage = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .allowsTightening(true)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .allowsTightening(true)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(imageName: self.countries[number])
                    }
                }
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .onReceive(timer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        } else {
                            self.dismissTitle = "Start Again"
                            self.showingOutOfTime = true
                        }
                }
                .alert(isPresented: $showingScore) {
                    Alert(title: Text(scoreTitle), message: Text("\(scoreMessage) \(finalScore)"), dismissButton: .default(Text("\(dismissTitle)")) {
                            self.askQuestion()
                        })
                }
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                .alert(isPresented: $showingOutOfTime) {
                    Alert(title: Text("Out Of Time!"), message: Text("\(scoreMessage) \(finalScore)"), dismissButton: .default(Text("\(dismissTitle)")) {
                            self.askQuestion()
                        })
                }
                Spacer()
            }
        }
    }
    
    
    func flagTapped(_ number: Int) {
        self.timer.upstream.connect().cancel()
        if number == correctAnswer {
            scoreTitle = "Correct"
            dismissTitle = "Continue"
            scoreMessage = "Your score is"
            score += 1
            finalScore = score
        } else {
            scoreTitle = "Wrong \nThat flag is \(countries[number])!"
            dismissTitle = "Start Again"
            scoreMessage = "Your final score is"
            score = 0
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        timeRemaining = timeRemainingCalculation()
        countries.shuffle()
        finalScore = 0
        correctAnswer = Int.random(in: 0...2)
        self.timer = Timer.publish (every: 1, on: .main, in: .common).autoconnect()
    }
    
    func timeRemainingCalculation() -> Int {
        switch score {
        case 0 ..< 10:
            return 10
        case 10 ..< 15:
            return 7
        case 15 ..< 20:
            return 5
        default:
            return 3
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
