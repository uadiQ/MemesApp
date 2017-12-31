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

struct Meme: Equatable {
    
    let id: Int
    //let urlString: String
    let url: URL
    let name: String
    let height: Int
    let width: Int
}

extension Meme {
    init?(json: JSON) {
        guard let url = json["url"].url else { return nil }
        self.height = json["height"].intValue
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
        //self.urlString = json["url"].stringValue
        self.width = json["width"].intValue
        self.url = url
    }
}

extension Meme {
    static func == (lhs: Meme, rhs: Meme) -> Bool {
        return lhs.id == rhs.id
    }
}
