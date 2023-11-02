//
//  ImagePicker.swift
//  Gestures3
//
//  Created by Cristi Isaula-Reyes on 11/2/23.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPickerShowing {
            selectedImage = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}


class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // run code when user has selected an image
        print("image selected")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // we were able to get the image
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        // dismiss the picker
        parent.isPickerShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // run code when the user has canceled
        print("canceled")
        // dismiss the picker
        parent.isPickerShowing = false
    }
}
