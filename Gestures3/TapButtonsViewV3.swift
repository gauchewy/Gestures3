//
//  TapButtonsViewV3.swift
//  Gestures3
//
//  Created by Qiwei on 1/23/24.
//



import SwiftUI

struct TapButtonsViewV3: View {
    @State var viewCleared: Bool = false
    
    var onComplete: () -> Void

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
                            .fill(Color.yellow)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                    }
                    
                    VStack {
                        Spacer()
                        StackButtons3(width: geometry.size.width, 
                                      height: geometry.size.height
                        )
                            .padding()
                    }
                }
            }
        }
    }
}

struct StackButtons3: View {
    let width: CGFloat
    let height: CGFloat
    let buttonRadius = 60.0
    let vShape = [0.0, 0.0] // Two rows
    let hButtons = ["1", "2", "3"]
    let growRatio = 1.00
    @State private var highlightedIndexes: [Int]

    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        // Initialize highlighted indexes for each row
        self._highlightedIndexes = State(initialValue: [0, hButtons.count - 1]) // Start with first row at 0 and second row at the end
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(vShape.indices, id: \.self) { rowIndex in
                HStack {
                    Spacer()
                    
                    ForEach(hButtons.indices, id: \.self) { buttonIndex in
                        Button(action: {}){
                            Circle()
                                .frame(width: highlightedIndexes[rowIndex] == buttonIndex ? buttonRadius * growRatio : buttonRadius,
                                       height: highlightedIndexes[rowIndex] == buttonIndex ? buttonRadius * growRatio : buttonRadius)
                                .foregroundColor(highlightedIndexes[rowIndex] == buttonIndex ? .blue : .white)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                withAnimation {
                    // Update highlighted indexes for each row
                    highlightedIndexes[0] = (highlightedIndexes[0] + 1) % hButtons.count // Move forward for the first row
                    highlightedIndexes[1] = (highlightedIndexes[1] - 1 + hButtons.count) % hButtons.count // Move backward for the second row
                }
            }
        }
    }
}



struct TapButtonsViewV3_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV3(onComplete: {
            print("completed")
        })
    }
}

