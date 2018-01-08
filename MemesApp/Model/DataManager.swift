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
        ///////////// DOESN'T WORK
        guard let dataMemesArray = (allMemesArray) as? Data else { print("cannot convert to data"); return }
        
        documentsUrl.appendPathComponent(Utils.fileName)
        do {
            try dataMemesArray.write(to: documentsUrl)
            print("File was saved")
        } catch { print("file wasnt saved") }
    }
    
    func loadFavMemes(for user: String) {
        
        var pathToLoad = Utils.pathInDocument(with: user)
        pathToLoad.appendPathComponent(Utils.fileName)
        do {
          // let dataArray = try Array
        } catch {
           print("Loading failed")
        }
        
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
