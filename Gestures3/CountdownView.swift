//
//  CountdownView.swift
//  Gestures3
//
//  Created by Qiwei on 2/25/24.
//

import SwiftUI

struct CountdownView: View {
    @State private var countdown = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Spacer()
            Text("Next gesture in...")
                .font(.title)

            Text("\(countdown)")
                .font(.largeTitle)
                .onReceive(timer) { _ in
                    if countdown > 0 {
                        countdown -= 1
                    }
                }
            Spacer()
        }
    }
}

#Preview {
    CountdownView()
}
