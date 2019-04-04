//
//  ViewController.swift
//  ObjectRecognizer
//
//  Created by Andy Wu on 3/13/19.
//  Copyright © 2019 Andy Wu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var img: UIImage?
    var imgPath: URL?
    var data: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: ViewController) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) -> Void in self.camera()}))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) -> Void in self.photoLibrary()}))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func takePicBtn(_ sender: Any) {
        self.showActionSheet(vc: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "result" {
            let resultVC = segue.destination as! ResultsViewController
            if let image = self.img {
                resultVC.img = image
                resultVC.returnedData = data
            }
        }
    }
    
    func uploadImg() {
        let imgPathString: String = self.imgPath!.absoluteString
        let headers = Key.init().configKey
        let parameters = ["image":imgPathString]
        let url = "https://microsoft-azure-microsoft-computer-vision-v1.p.rapidapi.com/analyze?visualfeatures=Categories%2CTags%2CColor%2CFaces%2CDescription"
        
        guard let imgData = self.img?.jpegData(compressionQuality:0.2) else { return }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        },
                         to:url, headers: headers)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value!)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error!", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            print("Error saving photo!")
        } else {
            
            let ac = UIAlertController(title: "Save Successfully!", message: "Your image was saved successfully", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            
            print(contextInfo)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { 
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("Something went wrong!")
            return
        }
        
        self.img = image
        self.uploadImg()
        
        /*
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = UUID().uuidString + ".jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.jpegData(compressionQuality: 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    self.imgPath = fileURL
                    //print("file saved")
                    print("File Path: \(fileURL.absoluteString)")
                    self.uploadImg()
                } catch {
                    print("error saving file:", error)
                }
            }
         }
         */
    
    }
}
