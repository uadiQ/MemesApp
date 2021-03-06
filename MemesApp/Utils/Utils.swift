//
//  Utils.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 08.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit

struct Utils {
    
    static let email = "email"
    
    static var documentsUrl: URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {fatalError("Smth went wrong")}
        return path
    }
    static let fileName = "memesArray"
    static func pathInDocument(with user: String) -> URL {
        var pathToSend = documentsUrl
        pathToSend.appendPathComponent(user)
        return pathToSend
    }
}
