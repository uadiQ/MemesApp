//
//  DataManager.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 10.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private var email: String = "defaultemail@nomail.com"
    private(set) var memesArray: [Meme] = []
    func setEmail(with email: String) {
        self.email = email
    }
    func addMeme(meme: Meme) {
        memesArray.append(meme)
        NotificationCenter.default.post(name: .MemeAdded, object: nil)
    }
    
    func getMemeIndex(of meme: Meme) -> Int? {
        var memeIndex: Int?
        for (index, item) in memesArray.enumerated() where meme.id == item.id {
                memeIndex = index
                break
        }
        return memeIndex
    }
    
    func deleteMeme(meme: Meme) {
        guard let deletingIndex = getMemeIndex(of: meme) else { fatalError("Cannot delete notexisting meme") }
        memesArray.remove(at: deletingIndex)
        NotificationCenter.default.post(name: .MemeDeleted, object: nil)
    }
    
}
