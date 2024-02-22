

import SwiftUI

struct TapButtonsViewV2: View {
    @State var viewCleared: Bool = false
    let buttonRadius = 60.0
    let vShape = [30.0, 100.0, 200.0]
    
    let beigeColor = Color(red: 0.96, green: 0.96, blue: 0.86)
    
    @State private var timeRemaining = 180 // 180 seconds for 3 minutes
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var resetCounter = 0 // Counter for tracking viewCleared resets
    @State private var lastResetTime = Date()

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


struct TapButtonsViewV2_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV2(onComplete: {
            print("Complete task action from preview")
        })
    }
}


