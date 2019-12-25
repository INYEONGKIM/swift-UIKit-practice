//
//  NewsDetailController.swift
//  TableViewPractice
//
//  Created by INYEONGKIM on 2019/12/25.
//  Copyright © 2019 INYEONGKIM. All rights reserved.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    // 1. image url
    // 2. desc
    
    var imageURL : String?
    var desc : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // img
        if let img = imageURL {
            if let data = try? Data(contentsOf: URL(string: img)!){
                // Main thread
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data: data)
                }
            }
        }
        
        // 본문
        if let d = desc {
            self.LabelMain.text = d // 간단
        }
    }
}
