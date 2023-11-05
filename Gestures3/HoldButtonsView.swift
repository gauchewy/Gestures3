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
                }
                //entire vstack is the camera
                VStack {
                    HStack{
                        Spacer()

                        StackButtons()
                            .padding()
                    }
                }
            }
        }
    }
}




struct StackButtons: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                ForEach([0.35, 0.25, 0.15], id: \.self) { spacerRatio in
                    HStack {
                        Spacer().frame(width: geometry.size.width * spacerRatio)
                        Button(action: {}){
                            Circle().frame(width: 50, height: 50)
                        }
                        Spacer().frame(width: geometry.size.width * (0.5 - spacerRatio))
                        Button(action: {}){
                            Circle().frame(width: 50, height: 50)
                        }
                        Spacer().frame(width: geometry.size.width * spacerRatio)
                    }
                }
                Spacer()
            }
            .frame(width: geometry.size.width, alignment: .bottom)
        }
    }
}

struct HoldButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        HoldButtonsView()
    }
}
