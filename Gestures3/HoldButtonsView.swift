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
                    
                    if !viewCleared{
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
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach([0.3, 0.2, 0.1], id: \.self) { spacerRatio in
                HStack {
                    Spacer().frame(width: width * CGFloat(spacerRatio)-CGFloat(buttonwidth / 2))
                    Button(action: {}){
                        Circle().frame(width: buttonwidth, height: buttonwidth)
                    }
                    Spacer().frame(width: width * (0.5 - spacerRatio))
                    Button(action: {}){
                        Circle().frame(width: buttonwidth, height: buttonwidth)
                    }
                    Spacer().frame(width: width * spacerRatio)
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
