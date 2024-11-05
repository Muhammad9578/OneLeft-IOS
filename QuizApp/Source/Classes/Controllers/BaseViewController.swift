//
//  BaseViewController.swift
//  QuizApp
//
//  Created by user on 06/09/2021.
//

import UIKit
import MobileCoreServices
import AVKit

typealias EncodeVideoUrlCompletion = (_ videoUrl: URL?, _ videoExtension: String?) -> Void

class BaseViewController: UIViewController {

    var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.videoQuality = .typeMedium
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

}


extension BaseViewController {
    
    func showSelectionSheet(imageOrVideo: String, firstAct: String, secondAct: String) {
        let alert = UIAlertController(title: "", message: "Upload Attachment.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: firstAct, style: .default, handler: { (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: secondAct, style: .default , handler:{ (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler:{ (UIAlertAction) in
        }))
        present(alert, animated: true, completion: nil)
    }
    func showImageSelectionSheet(imageOrVideo : String) {
        let alert = UIAlertController(title: "", message: "Upload Attachment", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default , handler:{ (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler:{ (UIAlertAction) in
            self.pickPhoto(imageOrVideo: imageOrVideo, sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    func pickPhoto(imageOrVideo: String,sourceType: UIImagePickerController.SourceType) {
        switch sourceType {
        case .camera:
            imagePicker.sourceType = sourceType
            imagePicker.modalPresentationStyle = .fullScreen
            if imageOrVideo == "image" {
                imagePicker.mediaTypes = [(kUTTypeImage as String)]
                imagePicker.cameraCaptureMode = .photo
            }else if imageOrVideo == "video" {
                imagePicker.mediaTypes = [(kUTTypeMovie as String)]
                imagePicker.cameraCaptureMode = .video
            }
            
        case .photoLibrary:
            imagePicker.sourceType = sourceType
            if imageOrVideo == "image" {
                imagePicker.mediaTypes = [(kUTTypeImage as String)]
            }else if imageOrVideo == "video" {
                imagePicker.mediaTypes = [(kUTTypeMovie as String)]
            }
            
        default: break
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
}

