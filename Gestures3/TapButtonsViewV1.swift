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

    var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    Image("treehouse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    if !viewCleared {
                        Rectangle()
                            .fill(Color.green)
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
        }
    }
}

struct StackButtons: View {
    let width: CGFloat
    let height: CGFloat
    let buttonRadius: Double
    let vShape: [Double]
    let growRatio = 1.09
    @State private var highlightedIndex = 0
    @State private var firstButtonPressed = false
    @State private var secondButtonPressed = false
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
                         
                            }
                            else{
                                firstButtonPressed = false
                                viewCleared = false
                            }
                            checkButtonsPressed()
                            
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
                  
                            }
                            else{
                                secondButtonPressed = false
                                viewCleared = false
                            }
                            checkButtonsPressed()
                            
                        }, perform: {
                            
                        })
                    Spacer()
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
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
            // Set viewCleared to true only if both buttons are pressed
            viewCleared = firstButtonPressed && secondButtonPressed

            // As soon as one of the buttons is released, set viewCleared to false
            if !firstButtonPressed || !secondButtonPressed {
                viewCleared = false
            }
        }
}


struct TapButtonsViewV1_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV1()
    }
}
