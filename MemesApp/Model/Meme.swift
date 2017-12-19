//
//  Meme.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 10.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

struct Meme {
    let id: Int
    let urlString: String
   // var image: UIImage
    let name: String
    let height: Int
    let width: Int
}

extension Meme {
    init?(json: JSON) {
        self.height = json["height"].intValue
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
        self.urlString = json["url"].stringValue
        self.width = json["width"].intValue
    }
}
