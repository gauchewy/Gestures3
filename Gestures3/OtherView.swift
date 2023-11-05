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
    }
}

struct OtherView: View {
    let selection: SelectedOption
    @State var viewCleared: Bool = false

    var body: some View {
        
        VStack{
            
            Text("You selected \(selection.rawValue)")
            
            ZStack{
                Image("treehouse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
                if !viewCleared{
                    Rectangle()
                        .fill(Color.green)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }
    }
}
