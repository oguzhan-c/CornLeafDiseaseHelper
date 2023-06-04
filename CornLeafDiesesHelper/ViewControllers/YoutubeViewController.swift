//
//  YoutubrViewController.swift
//  CornLeafDiesesHelper
//
//  Created by Oğuzhan Can on 27.05.2023.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {
    
    @IBOutlet weak var webWiew: WKWebView!
    @IBOutlet weak var DieseName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    override func viewDidLoad() {
           super.viewDidLoad()
        
        configure()
       }
       
       public func configure() {
           let filteredString = navigationItem.title!.components(separatedBy: "-").first?.replacingOccurrences(of: "_", with: "")
           print(filteredString)
           if filteredString == "GrayLeafSpot "{
               guard let url = URL(string: "www.youtube.com/embed/107Xz8HslXM")
               else {
                   return
               }
               webWiew.load(URLRequest(url: url))
           }
           else if filteredString == "CommonRust "{
               guard let url = URL(string: "https://www.youtube.com/embed/OpHhh_1zkSg")
               else {
                   return
               }
               webWiew.load(URLRequest(url: url))
           }
           else if filteredString == "Blight "{
               guard let url = URL(string: "https://www.youtube.com/embed/uafRy5EqwBQ")
               else {
                   return
               }
               webWiew.load(URLRequest(url: url))
           }
         
       }
}
