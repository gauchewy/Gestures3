//
//  HoldButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import SwiftUI

struct HoldButtonsView: View {
    @State var viewCleared: Bool = false

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
                        StackButtons(width: geometry.size.width, height: geometry.size.height)
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
    let buttonwidth = 50.0
    let buttonRadius = 50.0
    let vShape = [0.05, 0.2, 0.4]
    let growRatio = 1.05
    @State private var highlightedIndex = 0

    var body: some View {
        VStack(spacing: 20) {
            ForEach(vShape.indices, id: \.self) { index in
                HStack {
                    Spacer().frame(width: width * CGFloat(vShape[index])-CGFloat(buttonwidth / 2))
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonwidth * growRatio : buttonwidth,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer().frame(width: width * (0.5 - vShape[index]))
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonwidth * growRatio : buttonwidth,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer().frame(width: width * vShape[index])
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

struct HoldButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        HoldButtonsView()
    }
}
