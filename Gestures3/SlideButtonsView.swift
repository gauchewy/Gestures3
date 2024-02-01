//
//  SlideButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 2/1/24.
//

import SwiftUI

struct SlideButtonsView: View {
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
                            .fill(Color.purple)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                    }
                    
                    VStack {
                        Spacer()
                       
                        DragGestureView()
                        
                            .padding()
                    }
                }
            }
        }
    }
}

struct ArcView: View {
    let start: CGPoint
    let end: CGPoint
    let radius: CGFloat
    var body: some View {
        Path { path in
            path.move(to: start)
            path.addArc(center: CGPoint(x: start.x, y: (start.y + end.y) / 2), radius: radius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: end)
        }
        .stroke(Color.green, lineWidth: 2)
    }
}

struct DragGestureView: View {
    let radius: CGFloat = 60
    @State private var animate = false
    
    var body: some View {
        VStack {
            ArcView(start: CGPoint(x: UIScreen.main.bounds.width / 2 - radius, y: 70), end: CGPoint(x: UIScreen.main.bounds.width / 2 + radius, y: 80), radius: radius)
            VStack {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index % 2 == 0 ? Color.red : Color.blue)
                        .frame(width: 50, height: 50)
                        .offset(x: animate ? (index % 2 == 0 ? radius : -radius) : 0)
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: true), value: animate)
                        .onAppear {
                            self.animate = true
                        }
                }
            }
        }
    }
}


struct DragGestureView_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureView()
    }
}

#Preview {
    SlideButtonsView()
}
