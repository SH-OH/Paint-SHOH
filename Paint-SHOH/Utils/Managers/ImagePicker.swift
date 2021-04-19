//
//  ImagePicker.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit.UIImagePickerController

final class ImagePicker: UIImagePickerController {
    
    typealias ImagePickerCompletion = (UIImage?) -> Void
    
    private var completion: ImagePickerCompletion?
    
    func present(
        _ title: String? = nil,
        to presentViewController: BaseViewController,
        completion: @escaping ImagePickerCompletion
    ) {
        delegate = self
        sourceType = .savedPhotosAlbum
        self.completion = completion
        presentViewController.present(
            self,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            self.completion?(nil)
            return
        }
        self.completion?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MAKR: - UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate {}
