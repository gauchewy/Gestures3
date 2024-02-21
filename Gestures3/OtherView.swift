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
    
    let beigeColor = Color(red: 0.96, green: 0.96, blue: 0.86)
    
    var imageName: String {
           switch selection {
           case .frame:
               return "hand drawings-01"
           case .binoculars:
               return "hand drawings-02"
           case .wave:
               return "hand drawings-04"
           case .interlace:
               return "hand drawings-03"
           default:
               return "hand drawings-04"
           }
       }
    

    var body: some View {
        
        VStack{
            
            //Text("You selected \(selection.rawValue)")
            
            ZStack{
                Image("treehouse")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
                
            if !viewCleared {
                                VStack{
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
        }
    }
}
