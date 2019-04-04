//
//  ResultsViewController.swift
//  ObjectRecognizer
//
//  Created by Andy Wu on 3/13/19.
//  Copyright © 2019 Andy Wu. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var img: UIImage?
    var returnedData: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.imgView.image = img
        self.textView.text = returnedData
    }
    
}

