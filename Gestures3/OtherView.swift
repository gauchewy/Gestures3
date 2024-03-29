//
//  OtherView.swift
//  Gestures3
//
//  Created by Qiwei on 11/2/23.
//

import Foundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    var selection: SelectedOption
    @Binding var viewCleared: Bool
    
    func makeUIViewController(context: Context) -> ViewController {
          let viewController = ViewController(selectedOption: selection) {
              self.viewCleared = $0
          }
          return viewController
      }
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        uiViewController.selectedOption = selection
    }
}

struct OtherView: View {
    let timeInSeconds: Int
    var selection: SelectedOption
    
    var onComplete: (([String: Any]) -> Void)? // for saving participant data
    var resetState: () -> Void = {}
    
    @State private var currentIndex = 0

    @State var viewCleared: Bool = false
    @State private var confLevel: Double = 0.9 // Default value
    @State private var timeRemaining = 180 // 180 seconds for 3 minutes
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var resetCounter = 0 // Counter for tracking viewCleared resets
    @State private var lastResetTime = Date()
    
    @Binding var isPoseDetected: Bool // for option 3
    
    let beigeColor = Color(red: 0.96, green: 0.96, blue: 0.86)
    
    init(selection: SelectedOption, timeInSeconds: Int, isPoseDetected: Binding<Bool>, onComplete: (([String: Any]) -> Void)? = nil, resetState: @escaping () -> Void = {}) {
            self.selection = selection
            self.timeInSeconds = timeInSeconds
            self._isPoseDetected = isPoseDetected
            self.onComplete = onComplete
            self.resetState = resetState
            self._timeRemaining = State(initialValue: timeInSeconds)
        }

    
    // a line of data 
    private func completeGesture() {
           let data: [String: Any] = [
               "gesture": selection.rawValue,
               "timeRemaining": timeRemaining,
               "resetCount": resetCounter
           ]
           onComplete?(data)
       }
    
    private func resetGestureView() {
            resetCounter = 0
            timeRemaining = timeInSeconds
            viewCleared = false
        }
    
    var imageName: String {
           switch selection {
           case .makeframe:
               return "hand drawings-01"
           case .binoculars:
               return "hand drawings-02"
           case .wave:
               return "hand drawings-04"
           case .interlace:
               return "hand drawings-05"  
           }
       }
    
    var titleName: String {
           switch selection {
           case .makeframe:
               return "Frame"
           case .binoculars:
               return "Binoculars"
           case .wave:
               return "Wave"
           case .interlace:
               return "Interlace"
           }
       }
    

    var body: some View {
        
        VStack{
            
            Text(titleName)
                .font(.subheadline)
            
            HStack{
                
                Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60) + " remaining")
                                .font(.headline)
                                .padding()
                                .onReceive(timer) { _ in
                                    if self.timeRemaining > 0 {
                                        self.timeRemaining -= 1
                                    }
                                }
                                .onAppear {
                                    self.timeRemaining = timeInSeconds // Reset the timer to 3 minutes
                                }
                
                Text("Reset Count: \(resetCounter)")
                               .font(.headline)
                               .padding()
            }
            
            //SLIDER HERE
            
//            VStack{
//                Slider(value: $confLevel, in: 0...1, step: 0.1)
//                    .padding()
//                Text("Confidence Level: \(confLevel, specifier: "%.1f")")
//                    .font(.subheadline)
//            }
//
            
            ZStack{
                UnlockedView()
                
                
            if !viewCleared {
            
                ZStack{
                    Rectangle()
                        .fill(beigeColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                }

                //entire vstack is the camera
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        CameraView(selection: selection, viewCleared: $viewCleared)
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 4)
                            .cornerRadius(20)
                            .padding()
                    }
                }
                //camera ends
            }
            .onChange(of: viewCleared) { newValue in
                           if newValue {
                               isPoseDetected = true // Update isPoseDetected when viewCleared changes
                           }
                           if !newValue && Date().timeIntervalSince(lastResetTime) >= 1 {
                               lastResetTime = Date()
                               resetCounter += 1
                           }
                       }
            .onAppear(){
                resetGestureView()
                            NotificationCenter.default.addObserver(forName: .resetGestureState, object: nil, queue: .main) { _ in
                                resetGestureView()
                            }
            }
            
        }
        
    }
    
}
extension Notification.Name {
    static let resetGestureState = Notification.Name("resetGestureState")
}
