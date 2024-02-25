//
//  TaskMainView.swift
//  Gestures3
//
//  Created by Qiwei on 2/12/24.


import SwiftUI

struct TaskMainView: View {
    @StateObject private var gestureState = GestureState()
    @State private var type = ["offGestures"]
    @State private var onGestures = [""]
    @State private var offGestures = ["interlace", "binoculars", "wave", "frame"]
    @State private var currentIndex = 0
    @State private var isScreenshotTaken = false
    
    @State private var currentParticipantNumber = 1
  //  @State private var participantDataList: [ParticipantData] = []
    
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
        //case nextButton = "Next Button"
        case detectPose = "Task Doable"
        case screenshot = "Task Deterable"
        
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
                if currentIndex < onGestures.count + offGestures.count {
                   // Display the current gesture view
                   gestureView(for: getCurrentGesture())

                   // Check if this is the last gesture
                   if currentIndex < onGestures.count + offGestures.count - 1 {
                       // Not the last gesture - show "Next Gesture" button
                       Button("Next Gesture") {
                           moveToNextGesture()
                       }
                       .padding()
                   } else {
                       // Last gesture - show completion text
                       Text("Task Complete")
                   }
               } else {
                   // All tasks are completed
                   Text("All tasks completed")
                       .padding()
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {  //TIME BETWEEN SCREEN MOVEMENT
                        moveToNextGesture()
                        isPoseDetected = false  // Reset the flag
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    private func getCurrentGesture() -> String {
           if type.first == "onGestures" {
               return currentIndex < onGestures.count ? onGestures[currentIndex] : offGestures[currentIndex - onGestures.count]
           } else {
               return currentIndex < offGestures.count ? offGestures[currentIndex] : onGestures[currentIndex - offGestures.count]
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
                return AnyView(OtherView(selection: .interlace, onComplete: { data in
                    //saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "binoculars":
                return AnyView(OtherView(selection: .binoculars, onComplete: { data in
                    //saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "wave":
                return AnyView(OtherView(selection: .wave, onComplete: { data in
                    //saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                
            case "frame":
                return AnyView(OtherView(selection: .frame, onComplete: { data in
                    //saveParticipantData(data)
                }, isPoseDetected: $isPoseDetected).id(resetKey))
                        
                
                
            default:
                return AnyView(Text("Unknown Gesture"))
            }
            
            
        }
//        
//    func saveParticipantData(_ gestureData: [String: Any]) {
//        guard let timeRemaining = gestureData["timeRemaining"] as? Int,
//              let resetCount = gestureData["resetCount"] as? Int else {
//            print("Invalid data format")
//            return
//        }
//
//        // Assuming the gesture name is already in 'gestureData' under a key like "gesture"
//        let gestureName = gestureData["gesture"] as? String ?? "Unknown"
//
//        // Format the data as "gesture; time left in timer; counts on counter"
//        let formattedData = "\(gestureName); \(timeRemaining); \(resetCount)"
//
//        // Create a dictionary with the formatted data
//        let formattedGestureData = ["data": formattedData]
//
//        // Create the ParticipantData object
//        let participantData = ParticipantData(participantNumber: currentParticipantNumber, gestureData: formattedGestureData)
//        participantDataList.append(participantData)
//
//        // Move to the next participant
//        moveToNextParticipant()
//    }

        
//        func moveToNextParticipant() {
//            if currentIndex >= onGestures.count + offGestures.count - 1 {
//                currentParticipantNumber += 1
//                currentIndex = 0 // Reset the index for the next participant
//                // Reset other states as needed for the next participant
//            } else {
//                moveToNextGesture()
//            }
//        }
        
        func moveToNextGesture() {
            if currentIndex < onGestures.count + offGestures.count - 1 {
                currentIndex += 1
                isScreenshotTaken = false
                resetKey = UUID()
            }
        }
    }
    

    
//    struct ParticipantData {
//        var participantNumber: Int
//        var gestureData: [String: Any]
//    }
    

