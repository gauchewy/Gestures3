//
//  SummaryView.swift
//  Gestures3
//
//  Created by Qiwei on 2/21/24.
//

import SwiftUI

struct SummaryView: View {
    var participantId: Int
    var gestureData: [String: Any] // Assuming this is how your data is structured

    var body: some View {
        VStack {
            Spacer()
            Text("Participant ID: \(participantId)")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            List(gestureData.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text(stringFromAny(gestureData[key]))
                }
            }
        }
        .navigationBarTitle("Summary", displayMode: .inline)
    }
    
    
    func stringFromAny(_ value: Any?) -> String {
        if let value = value {
            if let stringValue = value as? String {
                return stringValue
            } else if let numberValue = value as? NSNumber {
                return numberValue.stringValue
            } else {
                // Add more type conversions as needed
                return "\(value)"
            }
        } else {
            return "Unknown"
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(participantId: 1, gestureData: [
            "Gesture1": "Data for Gesture 1",
            "Gesture2": "Data for Gesture 2",
            // Add more sample gesture data as needed
        ])
    }
}
