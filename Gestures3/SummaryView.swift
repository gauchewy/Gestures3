//
//  SummaryView.swift
//  Gestures3
//
//  Created by Qiwei on 2/21/24.
//

import SwiftUI

struct SummaryView: View {
    var participantData: ParticipantData

    var body: some View {
        VStack {
            Spacer()
            Text("Participant ID: \(participantData.participantNumber)")
                .font(.title)
            List(participantData.gestureData.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                    Spacer()
                    Text(stringFromAny(participantData.gestureData[key]))
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
                return "\(value)"
            }
        } else {
            return "Unknown"
        }
    }
}
