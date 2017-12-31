//
//  DataManager.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 10.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private var email: String = "defaultemail@nomail.com"
    private(set) var allMemesArray: [Meme] = []
    private(set) var favMemesArray: [Meme] = []
    
    func setEmail(with email: String) {
        self.email = email
    }
    func addMeme(meme: Meme) {
        favMemesArray.append(meme)
        NotificationCenter.default.post(name: .MemeAdded, object: nil)
    }
    
    func deleteMeme(at index: Int) {
        favMemesArray.remove(at: index)
        NotificationCenter.default.post(name: .MemeDeleted, object: nil)
    }
    
    func setAllMemesArray(with array: [Meme]) {
        allMemesArray.removeAll()
        allMemesArray = array
    }
    
    func loadAllMemes() {
        Alamofire.request("https://api.imgflip.com/get_memes").responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonResponse = JSON(value)
                guard let memesJSONArray = jsonResponse["data"]["memes"].array else { fatalError("Didn't turn into array") }
                for jsonMeme in memesJSONArray {
                    guard let meme = Meme(json: jsonMeme) else { print("Meme hasn't been created"); continue }
                    self.allMemesArray.append(meme)
                }
                print(self.allMemesArray)
                NotificationCenter.default.post(name: .AllMemesLoaded, object: nil)
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
