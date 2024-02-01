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
                        radius: 80,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(90),
                        clockwise: index % 2 == 0)
        }
    }

    var body: some View {
        
            VStack {
                Spacer()
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index % 2 == 0 ? Color.red : Color.blue)
                        .frame(width: 50, height: 50)
                        .modifier(FollowEffect(pct: self.calculatePct(for: index), path: self.createPath(index: index)))
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 2.0).repeatForever()) {
                                self.flag = true
                            }
                        }
                        .padding()
                }
                Spacer()
            }
    }
    
    private func calculatePct(for index: Int) -> CGFloat {
        // Even-indexed buttons move normally, odd-indexed buttons move in reverse
        return (index % 2 == 0) ? (self.flag ? 1 : 0) : (self.flag ? 0 : 1)
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
