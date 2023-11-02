//
//  ScratchView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import SwiftUI

struct ScratchView: View {
    @State var onFinish: Bool = false
    @State var visible: Double = 0.0
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ScratchCardView(cursorSize: 50, onFinish: $onFinish, visible: $visible) {
                VStack {
                    Image("treehouse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            } overlayView: {
                Image("pattern")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onReceive(timer) { _ in
            if visible < 1 {
                withAnimation(.linear(duration: 0.01)) {
                    visible += 0.01
                }
            }
        }
    }
    
    
    struct ScratchView_Previews: PreviewProvider {
        static var previews: some View {
            ScratchView()
        }
    }
    
    struct ScratchCardView<Content: View,overlayImage:View>: View {
        var content: Content
        var overlayView: overlayImage
        var cursorSize: CGFloat
        @Binding var onFinish: Bool
        @Binding var visible: Double
        @State var startingPoint: CGPoint = .zero
        @State var points: [CGPoint] = []

        init(cursorSize: CGFloat, onFinish: Binding<Bool>, visible: Binding<Double>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder overlayView: @escaping () -> overlayImage){
            self.content = content()
            self.overlayView = overlayView()
            self.cursorSize = cursorSize
            self._onFinish = onFinish
            self._visible = visible
        }
        
        var body: some View {
            ZStack {
                overlayView
                
                content
                    .mask(ScratchMask(points: points, startingPoint: startingPoint)
                        .stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .round, lineJoin: .round)).opacity(visible))
                    .gesture(
                       DragGesture()
                          .onChanged { value in
                              if self.startingPoint == .zero {
                                  withAnimation {
                                      self.startingPoint = value.location
                                  }
                                  // Start the timer for regrowing
                                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                      withAnimation {
                                          self.points = []
                                          self.startingPoint = .zero
                                          visible = 0
                                      }
                                  }
                              }
                              self.points.append(value.location)
                          }
                     )
            }
            .frame(width: 350, height: 300)
            .cornerRadius(10)
        }
        
    }
    
    //scratch mask
    struct ScratchMask: Shape {
        var points:[CGPoint]
        var startingPoint: CGPoint
        
        
        func path(in rect: CGRect) -> Path{
            return Path{path in
                path.move(to:startingPoint)
                path.addLines(points)
            }
        }
    }
}
