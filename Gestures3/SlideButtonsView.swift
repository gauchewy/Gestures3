//
//  SlideButtonsView.swift
//  Gestures3
//
//  Created by Qiwei on 2/1/24.
//

import SwiftUI

struct SlideButtonsView: View {
    @State var viewCleared: Bool = false
    let beigeColor = Color(red: 0.96, green: 0.96, blue: 0.86)
    var onComplete: () -> Void

    @State private var timeRemaining = 180 // 180 seconds for 3 minutes
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var resetCounter = 0 // Counter for tracking viewCleared resets
    @State private var lastResetTime = Date()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack{
                    Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60) + " remaining")
                        .font(.headline)
                        .padding()
                    
                    Text("Reset Count: \(resetCounter)")
                        .font(.headline)
                        .padding()
                }
                ZStack {
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
                        DragGestureView()
                            .padding()
                    }
                }
                
            }
            .onReceive(timer) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
            .onAppear {
                self.timeRemaining = 180 // Reset the timer to 3 minutes
                self.resetCounter = 0
                self.lastResetTime = Date()
            }
            .onChange(of: viewCleared) { newValue in
                if !newValue && Date().timeIntervalSince(lastResetTime) >= 1 {
                    lastResetTime = Date()
                    resetCounter += 1
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
    SlideButtonsView(onComplete: {
        print("completed")
    })
}
