//
//  TaskMainView.swift
//  Gestures3
//
//  Created by Qiwei on 2/12/24.
//

import SwiftUI

struct TaskMainView: View {
    @StateObject private var gestureState = GestureState()
    @State private var type = ["onGestures", "offGestures"]
    @State private var onGestures = ["tap 1", "tap 2", "tap 3", "slide"]
    @State private var offGestures = ["interlace", "binoculars", "wave", "frame"]
    @State private var currentIndex = 0
    @State private var isScreenshotTaken = false
    
    @State private var currentParticipantNumber = 1
    @State private var participantDataList: [ParticipantData] = []
    
    @State private var isParticipantNumberEntered: Bool = false
    
    @State private var resetKey = UUID()
    @State private var progressMethod: ProgressOption = .screenshot
    
    @State private var isPoseDetected: Bool = false
    
    
    init() {
        _type = State(initialValue: type.shuffled())
        _onGestures = State(initialValue: onGestures.shuffled())
        _offGestures = State(initialValue: offGestures.shuffled())
    }
    
    enum ProgressOption: String, CaseIterable, Identifiable {
        case screenshot = "Screenshot"
        case nextButton = "Next Button"
        case detectPose = "Detect Pose"
        
        var id: String { self.rawValue }
    }
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                if !isParticipantNumberEntered {
                    participantNumberInputView()
                } else {
                    gestureTaskView()
                }
            }
        }
        
    }
    
    private func participantNumberInputView() -> some View {
        VStack {
            Text("Enter Participant ID")
                .font(.title)
            TextField("Enter Participant Number", value: $currentParticipantNumber, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Picker("Progress Method", selection: $progressMethod) {
                ForEach(ProgressOption.allCases) { option in
                    Text(option.rawValue).tag(option)                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Submit") {
                print(progressMethod)
                isParticipantNumberEntered = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    private func gestureTaskView() -> some View {
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

                Button("Next Gesture") {
                    moveToNextGesture()
                    
                }
            }
            .onAppear {
                        if isPoseDetected && progressMethod == .detectPose {
                            moveToNextGesture()
                        }
                    }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                isScreenshotTaken = true
            }
            .onChange(of: isScreenshotTaken) { taken in
                if taken && progressMethod == .screenshot {
                    moveToNextGesture()
                }
            }
            .onChange(of: isPoseDetected) { detected in
                if detected && progressMethod == .detectPose {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        moveToNextGesture()
                        //reset it
                        isPoseDetected = false
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                return AnyView(OtherView(selection: .interlace, onComplete: { data in
                    saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "binoculars":
                return AnyView(OtherView(selection: .binoculars, onComplete: { data in
                    saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "wave":
                return AnyView(OtherView(selection: .wave, onComplete: { data in
                    saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "frame":
                return AnyView(OtherView(selection: .frame, onComplete: { data in
                    saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                        
                
                
            default:
                return AnyView(Text("Unknown Gesture"))
            }
        }
        
        func saveParticipantData(_ gestureData: [String: Any]) {
            let participantData = ParticipantData(participantNumber: currentParticipantNumber, gestureData: gestureData)
            participantDataList.append(participantData)
            moveToNextParticipant()
        }
        
        func moveToNextParticipant() {
            if currentIndex >= onGestures.count + offGestures.count - 1 {
                currentParticipantNumber += 1
                currentIndex = 0 // Reset the index for the next participant
                // Reset other states as needed for the next participant
            } else {
                moveToNextGesture()
            }
        }
        
        func moveToNextGesture() {
            if currentIndex < onGestures.count + offGestures.count - 1 {
                currentIndex += 1
                isScreenshotTaken = false
                resetKey = UUID()
            }
        }
    }
    
    
    
    struct ParticipantData {
        var participantNumber: Int
        var gestureData: [String: Any]
    }
    

