//
//  PictureVM.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/28/22.
//

import Foundation
import UIKit
import SwiftUI

// Structure for a view model that manages the selection of images.
struct PicturePicker: UIViewControllerRepresentable {
    @Binding var chosenPicture: UIImage?
    @Binding var pickerShowing: Bool
    @Binding var isLoading: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picturePicker = UIImagePickerController()
        picturePicker.sourceType = .photoLibrary
        picturePicker.delegate = context.coordinator
        isLoading = false
        return picturePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Required for conformity to UIViewControllerRepresentable type protocol.
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

// Coordinator class that helps manage image selection.
class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: PicturePicker

    init(_ picker: PicturePicker) {
        self.parent = picker
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // User has chosen an image.
        if let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // We can get the chosen image.
            self.parent.chosenPicture = picture
        }
        // Close the picture picker.
        parent.pickerShowing = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // User has exited the picture picker.
        parent.pickerShowing = false
    }
}
