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
                                     vShape: vShape
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
    let growRatio = 1.00
    @State private var highlightedIndex = 0

    var body: some View {
        VStack(spacing: 20) {
            ForEach(vShape.indices, id: \.self) { index in
                HStack {
                    Spacer()
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer().frame(width: vShape[index])
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
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
}

struct TapButtonsViewV1_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV1()
    }
}
