//
//  TaskMainView.swift
//  Gestures3
//
//  Created by Qiwei on 2/12/24.
//

import SwiftUI

struct TaskMainView: View {
    
    @State private var type = ["onGestures", "offGestures"]
    @State private var onGestures = ["tap 1", "tap 2", "tap 3", "slide"]
    @State private var offGestures = ["interlace", "binoculars", "wave", "frame"]
    @State private var currentIndex = 0
    @State private var isScreenshotTaken = false

    
    init() {
        _type = State(initialValue: type.shuffled())
        _onGestures = State(initialValue: onGestures.shuffled())
        _offGestures = State(initialValue: offGestures.shuffled())
    }
    
    
    var body: some View {
            NavigationView {
                VStack {
                    if type.first == "onGestures" {
                        if currentIndex < onGestures.count {
                            gestureView(for: onGestures[currentIndex])
                        } else if currentIndex < onGestures.count + offGestures.count {
                            gestureView(for: offGestures[currentIndex - onGestures.count])
                        }
                    } else {
                        if currentIndex < offGestures.count {
                            gestureView(for: offGestures[currentIndex])
                        } else if currentIndex < onGestures.count + offGestures.count {
                            gestureView(for: onGestures[currentIndex - offGestures.count])
                        }
                    }
                    
                    if currentIndex >= onGestures.count + offGestures.count {
                        Text("All tasks completed")
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                    isScreenshotTaken = true
                }
                .onChange(of: isScreenshotTaken) { taken in
                    if taken {
                        moveToNextGesture()
                    }
                }
            }
        }


        func gestureView(for gesture: String) -> some View {
            switch gesture {
                // on gestures
               case "tap 1":
                   return AnyView(TapButtonsViewV1(onComplete: moveToNextGesture))
               case "tap 2":
                   return AnyView(TapButtonsViewV2(onComplete: moveToNextGesture))
               case "tap 3":
                    return AnyView(TapButtonsViewV3(onComplete: moveToNextGesture))
               case "slide":
                    return AnyView(SlideButtonsView(onComplete: moveToNextGesture))
               
                // off gestures
               case "interlace":
                return AnyView(OtherView(selection:.interlace))
            case "binoculars":
                return AnyView(OtherView(selection:.binoculars))
            case "wave":
                return AnyView(OtherView(selection:.wave))
            case "frame":
                return AnyView(OtherView(selection: .handClasp))
                
                
               default:
                   return AnyView(Text("Unknown Gesture"))
               }
        }

    func moveToNextGesture() {
           if currentIndex < onGestures.count + offGestures.count - 1 {
               currentIndex += 1
               isScreenshotTaken = false
           }
       }
    }
#Preview {
    TaskMainView()
}
