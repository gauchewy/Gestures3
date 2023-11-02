//
//  ContentView.swift
//  Gestures2
//
//  Created by Qiwei on 10/11/23.
//

import SwiftUI

enum SelectedOption: String {
    case handClasp = "Hand Clasp"
    case binoculars = "Binoculars"
    case wave = "Wave"
    case interlace = "Interlace"
    case iscratch = "iScratch"
}

struct ContentView: View {
    @State private var isSettingsViewShown = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Welcome to Justure")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Spacer()

                ButtonGroupView()

                Spacer()

                NavigationLink(destination: ScratchView()) {
                    Text("iScratch")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                }.padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button(action: {
                                isSettingsViewShown = true
                            }) {
                                Image(systemName: "gear")
                                    .font(.title)
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Justure")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .sheet(isPresented: $isSettingsViewShown) {
                    SettingsView()
                }

                Spacer()
            }
        }
    }
}

struct ButtonGroupView: View {
    let actions: [SelectedOption] = [.handClasp, .binoculars, .wave, .interlace]

    var body: some View {
        VStack {
            ForEach(actions, id: \.self) { action in
                NavigationLink(destination: OtherView(selection: action)) {
                    Text(action.rawValue)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }.padding(.bottom)
            }
        }.padding()
    }
}

struct SettingsView: View {
    enum FocusedField {
        case int
    }
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State private var bufferTimeAmnt = ""
    @State private var timerClockAmnt = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            Spacer()
            Text("Settings")
                .font(.title)
                Spacer()
            
            HStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                
                Button {
                    // show image picker
                    isPickerShowing = true
                    
                } label: {
                    Text("Upload photo")
                }
                
                .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
                    // Image picker
                    ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                }
            }
            Text("Buffer time")
                .font(.title3)
            TextField("Enter time in seconds:", text: $bufferTimeAmnt)
                .focused($focusedField, equals: .int)
                .keyboardType(.numberPad)
            
            
            Text("Timer clock")
                .font(.title3)
            TextField("Enter time in minutes:", text: $timerClockAmnt)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .int)
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
        .frame(width: 200)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
