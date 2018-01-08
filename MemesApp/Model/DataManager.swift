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
import KeychainSwift

final class DataManager {
    static let instance = DataManager()
    private init() { email = keychain.get("email") }
    
    private(set) var email: String?
    private(set) var allMemesArray: [Meme] = []
    private(set) var favMemesArray: [Meme] = []
    let keychain = KeychainSwift()
    
    func setEmail(with email: String) {
        self.email = email
        keychain.set(email, forKey: "email")
    }
    func addMeme(meme: Meme) {
        favMemesArray.append(meme)
        NotificationCenter.default.post(name: .MemeAdded, object: nil)
    }
    
    func deleteMeme(at index: Int) {
        favMemesArray.remove(at: index)
        NotificationCenter.default.post(name: .MemeDeleted, object: nil)
    }
    
    func saveFavMemes(for user: String) {
        var documentsUrl = Utils.pathInDocument(with: user)
        if !FileManager.default.fileExists(atPath: String(describing: documentsUrl) ) {
            do {
                try FileManager.default.createDirectory(at: documentsUrl, withIntermediateDirectories: true)
                print("Directory \(documentsUrl) was created")
            } catch {
                print("Directory wasnt created")
            }
        }
        
        documentsUrl.appendPathComponent(Utils.fileName)
        (favMemesArray as NSArray).write(to: documentsUrl, atomically: true)
            print("File was saved")
    }
    
    func loadFavMemes(for user: String) {
        
        var pathToLoad = Utils.pathInDocument(with: user)
        pathToLoad.appendPathComponent(Utils.fileName)
            guard let arrayToLoad = NSArray(contentsOf: pathToLoad) as? [Meme] else {print( "failed"); return}
            setFavMemesArray(with: arrayToLoad)
    }
    
    func setFavMemesArray(with array: [Meme]) {
        favMemesArray.removeAll()
        favMemesArray = array
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
