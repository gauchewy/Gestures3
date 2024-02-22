//
//  HoldButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import SwiftUI

struct TapButtonsViewV1: View {
    @State var viewCleared: Bool = false
    let buttonRadius = 60.0
    let vShape = [200.0, 100.0, 30.0]
    
    @State private var timeRemaining = 180 // 180 seconds for 3 minutes
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var resetCounter = 0 // Counter for tracking viewCleared resets
    @State private var lastResetTime = Date()
    
    let beigeColor = Color(red: 0.96, green: 0.96, blue: 0.86)
    
    var onComplete: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack{
                
                HStack{
                    
                    Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60) + " remaining")
                                    .font(.headline)
                                    .padding()
                                    .onReceive(timer) { _ in
                                        if self.timeRemaining > 0 {
                                            self.timeRemaining -= 1
                                        }
                                    }
                                    .onAppear {
                                        self.timeRemaining = 180 // Reset the timer to 3 minutes
                                    }
                    
                    Text("Reset Count: \(resetCounter)")
                                   .font(.headline)
                                   .padding()
                }
                
                ZStack{
                    Image("treehouse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    if !viewCleared {
                        Rectangle()
                            .fill(beigeColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                    }
                    
                    VStack {
                        Spacer()
                        StackButtons(width: geometry.size.width,
                                     height: geometry.size.height,
                                     buttonRadius: buttonRadius,
                                     vShape: vShape,
                                     viewCleared: $viewCleared // Binding
                        )
                            .padding()
                    }
                }
            }
            .onChange(of: viewCleared) { newValue in
                            if !newValue && Date().timeIntervalSince(lastResetTime) >= 1 {
                                lastResetTime = Date()
                                resetCounter += 1
                            }
                        }
                        .onAppear {
                            resetCounter = 0
                            timeRemaining = 180
                        }
        }
    }
}

struct StackButtons: View {
    let width: CGFloat
    let height: CGFloat
    let buttonRadius: Double
    let vShape: [Double]
    let growRatio = 1.09
    let timeInterval = 1.0
    @State private var highlightedIndex = 0
    @State private var firstButtonPressed = false
    @State private var secondButtonPressed = false
    @State private var lastPressedTime = Date()
    @Binding var viewCleared: Bool // Binding to parent state

    var body: some View {
        VStack(spacing: 20) {
            ForEach(vShape.indices, id: \.self) { index in
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: firstButtonPressed && highlightedIndex == index ? buttonRadius * growRatio : buttonRadius,
                               height: firstButtonPressed && highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                        .foregroundColor(highlightedIndex == index ? .blue : .white)
                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                            if highlightedIndex == index {
                                firstButtonPressed = pressing
                                checkButtonsPressed()
                                lastPressedTime = Date()
                            }
                         
                        }, perform: {

                        })
                    Spacer().frame(width: vShape[index])
                    Circle()
                        .frame(width: secondButtonPressed && highlightedIndex == index ? buttonRadius * growRatio : buttonRadius,
                               height: secondButtonPressed && highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                        .foregroundColor(highlightedIndex == index ? .blue : .white)
                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                            if highlightedIndex == index {
                                secondButtonPressed = pressing
                                checkButtonsPressed()
                                lastPressedTime = Date()
                            }
                           
                        }, perform: {

                        })
                    Spacer()
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
                // Animate the index increasing
                withAnimation {
                    if highlightedIndex < vShape.count - 1 {
                        highlightedIndex += 1
                    } else {
                        highlightedIndex = 0
                    }
                }
            }
        }
    }
    

    private func checkButtonsPressed() {
        // As soon as one of the buttons is released, set viewCleared to false
        if !firstButtonPressed || !secondButtonPressed {
            print("button released")
            viewCleared = false
        }

        // if the press lasts longer than the duration variable, set viewCleared to false
        if Date().timeIntervalSince(lastPressedTime) > timeInterval {
            print("press lasted longer than dur")
            viewCleared = false
        }
        else if firstButtonPressed && secondButtonPressed{
            viewCleared = true
        }
    }
}


struct TapButtonsViewV1_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV1(onComplete: {
            print("completed")
        })
    }
}
