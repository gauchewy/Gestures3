//
//  TaskMainView.swift
//  Gestures3
//
//  Created by Qiwei on 2/12/24.


import SwiftUI

struct TaskMainView: View {
    @StateObject private var gestureState = GestureState()
    @State private var offGestures = ["interlace", "binoculars", "wave", "frame"]
    @State private var currentIndex = 0
    @State private var selection: SelectedOption = .wave
    @State private var isScreenshotTaken = false
    @State private var showCountdown = false
    
    @State private var isTaskComplete = false
    
    @State private var currentParticipantNumber = 1
    //  @State private var participantDataList: [ParticipantData] = []
    
    @State private var isParticipantNumberEntered: Bool = false
    
    @State private var resetKey = UUID()
    @State private var progressMethod: ProgressOption = .screenshot
    @State private var timeMethod: TimeOption = .onemin
    
    @State private var isPoseDetected: Bool = false
    
    
    init() {
        _offGestures = State(initialValue: offGestures.shuffled())
    }
    
    enum ProgressOption: String, CaseIterable, Identifiable {
        //case nextButton = "Next Button"
        case detectPose = "Task Doable"
        case screenshot = "Task Deterable"
        
        var id: String { self.rawValue }
    }
    
    enum TimeOption: String, CaseIterable, Identifiable {
        //case nextButton = "Next Button"
        case onemin = "1 minute"
        case twomin = "2 minutes"
        case threemin = "3 minutes"
        
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
            
            Picker("Time per gesture", selection: $timeMethod) {
                ForEach(TimeOption.allCases) { times in
                    Text(times.rawValue).tag(times)                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Submit") {
                print(progressMethod)
                offGestures = offGestures.shuffled()
                print(offGestures)
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
                if showCountdown {
                    CountdownView()
                } else if !isTaskComplete {
                    // Display the current gesture view
                    gestureView(for: getCurrentGesture())
                    
                    if currentIndex < offGestures.count {
                        // Not the last gesture - show "Next Gesture" button
                        Button("Next Gesture") {
                            moveToNextGesture()
                        }
                        .padding()
                    }
                    
                }
                else{
                    Text("Tasks complete")
                        .font(.subheadline)
                }
            }
            .onAppear {
                updateSelection()
                if isPoseDetected && progressMethod == .detectPose {
                    moveToNextGesture()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                if progressMethod == .screenshot && isPoseDetected {
                    self.showCountdown = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        self.showCountdown = false
                    }
                    
                    moveToNextGesture()
                    isScreenshotTaken = false // Reset the flag
                    isPoseDetected = false // Reset the flag
                } else {
                    isScreenshotTaken = true
                }
            }
            .onChange(of: isPoseDetected) { detected in
                if detected && progressMethod == .detectPose {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  //TIME BETWEEN SCREEN MOVEMENT
                        self.showCountdown = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            self.showCountdown = false
                        }
                        
                        moveToNextGesture()
                        isPoseDetected = false  // Reset the flag
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    private func getCurrentGesture() -> String {
        
        return currentIndex < offGestures.count ? offGestures[currentIndex] : ""
        
    }
    
    
    
    
    func gestureView(for gesture: String) -> some View {
        let timeInSeconds = getTimeInSeconds(from: timeMethod)
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
            return AnyView(OtherView(selection: selection,
                                     timeInSeconds: timeInSeconds,
                                     isPoseDetected: $isPoseDetected,
                                     onComplete: { data in
            },
                                     resetState: {
            }))
            
        case "binoculars":
            return AnyView(OtherView(selection: selection,
                                     timeInSeconds: timeInSeconds,
                                     isPoseDetected: $isPoseDetected,
                                     onComplete: { data in
            },
                                     resetState: {
            }))
            
        case "wave":
            return AnyView(OtherView(selection: selection,
                                     timeInSeconds: timeInSeconds,
                                     isPoseDetected: $isPoseDetected,
                                     onComplete: { data in
            },
                                     resetState: {
            }))
            
        case "frame":
            return AnyView(OtherView(selection: selection,
                                     timeInSeconds: timeInSeconds,
                                     isPoseDetected: $isPoseDetected,
                                     onComplete: { data in
            },
                                     resetState: {
            }))
            
        default:
            return AnyView(Text("Complete"))
        }
        
        
    }
    
    private func getTimeInSeconds(from timeOption: TimeOption) -> Int {
        switch timeOption {
        case .onemin:
            return 60
        case .twomin:
            return 120
        case .threemin:
            return 180
        }
    }
    
    func moveToNextGesture() {
        if currentIndex < offGestures.count - 1 {
            currentIndex += 1
        } else {
            isTaskComplete = true
        }
        updateSelection()
        resetGestureState()
    }
    
    private func resetGestureState() {
        // Resetting the state for the new gesture
        isPoseDetected = false
        isScreenshotTaken = false
        resetKey = UUID()
        
        // Notify OtherView to reset its state
        NotificationCenter.default.post(name: .resetGestureState, object: nil)
    }
    private func updateSelection() {
        if !isTaskComplete {
            let gestureName = getCurrentGesture()
            print("Current Index: \(currentIndex), Gesture: \(gestureName)")
            if let newSelection = SelectedOption(rawValue: gestureName) {
                selection = newSelection
            }
        }
    }
}


