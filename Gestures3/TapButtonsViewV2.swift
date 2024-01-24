

import SwiftUI

struct TapButtonsViewV2: View {
    @State var viewCleared: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image("treehouse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    if !viewCleared {
                        Rectangle()
                            .fill(Color.pink)
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

struct StackButtons2: View {
    let width: CGFloat
    let height: CGFloat
    let buttonWidth = 80.0
    let buttonRadius = 80.0
    let vShape = [0.4, 0.2, 0.4]
    let growRatio = 1.00
    @State private var highlightedIndex = 0

    var body: some View {
        VStack(spacing: 20) {
            ForEach(vShape.indices, id: \.self) { index in
                HStack {
                    Spacer().frame(width: width * CGFloat(vShape[index]) - CGFloat(buttonWidth / 2))
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonWidth * growRatio : buttonWidth,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer().frame(width: width * (0.5 - vShape[index]))
                    Button(action: {}){
                        Circle()
                            .frame(width: highlightedIndex == index ? buttonWidth * growRatio : buttonWidth,
                                   height: highlightedIndex == index ? buttonRadius * growRatio : buttonRadius)
                            .foregroundColor(highlightedIndex == index ? .blue : .white)
                    }
                    Spacer().frame(width: width * vShape[index])
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
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

struct TapButtonsViewV2_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV2()
    }
}

