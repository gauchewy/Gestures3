//
//  HoldButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import SwiftUI

struct HoldButtonsView: View {
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            StackButtons()

        }
    }
}

struct StackButtons: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer().frame(width: geometry.size.width * 0.15)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.70)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.15)
                }
                HStack {
                    Spacer().frame(width: geometry.size.width * 0.25)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.50)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.25)
                }
                HStack {
                    Spacer().frame(width: geometry.size.width * 0.35)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.30)
                    Button(action: {}){
                        Circle().frame(width: 50, height: 50)
                    }
                    Spacer().frame(width: geometry.size.width * 0.35)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct HoldButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        HoldButtonsView()
    }
}
