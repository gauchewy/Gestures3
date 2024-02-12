

import SwiftUI

struct TapButtonsViewV2: View {
    @State var viewCleared: Bool = false
    let buttonRadius = 60.0
    let vShape = [30.0, 100.0, 200.0]

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
                            .fill(Color.pink)
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


struct TapButtonsViewV2_Previews: PreviewProvider {
    static var previews: some View {
        TapButtonsViewV2(onComplete: {
            print("Complete task action from preview")
        })
    }
}


