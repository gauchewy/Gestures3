//
//  UnlockedView.swift
//  Gestures3
//
//  Created by Qiwei on 2/25/24.
//

import SwiftUI

struct UnlockedView: View {
    var body: some View {
        VStack {

            
            Text("unlocked")
                .font(.largeTitle) // Large, bold font
                .fontWeight(.bold)
                .foregroundColor(Color.black) // Text color
                .padding()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.green) // Green check mark
                .font(.system(size: 120)) // Size of the check mark
            
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill screen
        .background(Color(red: 0.9, green: 1.0, blue: 0.9)) // Custom light green background
        .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the whole screen
    }
}

#Preview {
    UnlockedView()
}
