//
//  CameraHandler.swift
//  ObjectRecognizer
//
//  Created by Andy Wu on 3/13/19.
//  Copyright © 2019 Andy Wu. All rights reserved.
//

import Foundation
import UIKit

class CameraHandler: NSObject {
    //static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var img: UIImage?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: ViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) -> Void in self.camera()}))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) -> Void in self.photoLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Something went wrong!")
            return
        }
        
        print(image.size)
        self.img = image
        
        picker.dismiss(animated: true, completion: {
            self.currentVC.performSegue(withIdentifier: "result", sender: self.currentVC)
        })
        
        /*
         self.present(self, animated: true) {
         self.performSegue(withIdentifier: "result", sender: self)
         }
         */
    }
    
}
