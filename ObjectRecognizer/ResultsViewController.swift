//
//  ResultsViewController.swift
//  ObjectRecognizer
//
//  Created by Andy Wu on 3/13/19.
//  Copyright © 2019 Andy Wu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var img: UIImage?
    var json: JSON?
    var isHotdogPressed: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.imgView.image = img
        self.parseJSONData()
    }
    
    func parseJSONData() {
        if self.isHotdogPressed! {
            let tags = getTags(tags: json!["tags"])
            self.textView.text = tags
        } else {
            let category = getCategory(categories: json!["categories"])
            let tags = getTags(tags: json!["tags"])
            let caption = getCaption(captions: json!["description"]["captions"])
            self.textView.text = caption + category + tags
        }
    }
    
    func getCategory(categories: JSON) -> String {
        var categoryStr = ""
        var i = 1
        for category in categories.arrayValue {
            categoryStr += "Category \(i): \(category["name"].stringValue)\nScore: \(category["score"].stringValue)\n"
            i += 1
        }
        
        categoryStr += "\n"
        return categoryStr
    }
    
    func getTags(tags: JSON) -> String {
        var tagStr = ""
        var i = 1
        for tag in tags.arrayValue {
            if self.isHotdogPressed! {
                if tag["name"].stringValue.lowercased() == "hotdog" {
                    return "Hotdog!"
                }
            }
            
            tagStr += "Tag \(i): \(tag["name"].stringValue)\nConfidence: \(tag["confidence"].stringValue)\n"
            i += 1
        }
        
        if self.isHotdogPressed! {
            return "Not Hotdog"
        }
        
        tagStr += "\n"
        return tagStr
    }
    
    func getCaption(captions: JSON) -> String {
        var captionStr = ""
        var i = 1
        for caption in captions.arrayValue {
            captionStr += "Caption \(i): \(caption["text"].stringValue)\nConfidence: \(caption["confidence"].stringValue)\n"
            i += 1
        }
        
        captionStr += "\n"
        return captionStr
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

