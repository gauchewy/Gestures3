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

struct FollowEffect: GeometryEffect {
    var pct: CGFloat
    let path: Path

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let pathTrimmed = path.trimmedPath(from: 0, to: pct)
        let pt = pathTrimmed.currentPoint ?? .zero
        return ProjectionTransform(CGAffineTransform(translationX: pt.x - size.width / 2, y: pt.y - size.height / 2))
    }
}

struct DragGestureView: View {
    @State private var flag = false

    func createPath(index: Int) -> Path {
        Path { path in
            path.addArc(center: CGPoint(x: 30, y: 40),
                        radius: 70,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(90),
                        clockwise: index % 2 == 0)
        }
    }

    var body: some View {
        VStack {
            ForEach(0..<4) { index in
                Circle()
                    .fill(index % 2 == 0 ? Color.red : Color.blue)
                    .frame(width: 50, height: 50)
                    .modifier(FollowEffect(pct: self.flag ? CGFloat(3) / 4.0 : 0, path: self.createPath(index: index)))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                            self.flag = true
                        }
                    }
                    .padding()
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
