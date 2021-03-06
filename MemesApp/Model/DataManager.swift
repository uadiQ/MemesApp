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
    private init() { email = keychain.get(Utils.email) }
    
    private(set) var email: String?
    private(set) var allMemesArray: [Meme] = []
    private(set) var favMemesArray: [Meme] = []
    let keychain = KeychainSwift()
    
    func setEmail(with email: String) {
        self.email = email
        keychain.set(email, forKey: Utils.email)
    }
    
    func logout() {
        keychain.delete(Utils.email)
        email = nil
        favMemesArray.removeAll()
    }
    
    func addMeme(meme: Meme) {
        favMemesArray.append(meme)
        guard let emailToSave = email else { return }
        saveFavMemes(for: emailToSave)
        NotificationCenter.default.post(name: .MemeAdded, object: nil)
    }
    
    func deleteMeme(at index: Int) {
        favMemesArray.remove(at: index)
        guard let emailToSave = email else { return }
        saveFavMemes(for: emailToSave)
        NotificationCenter.default.post(name: .MemeDeleted, object: nil)
    }
    
    func saveFavMemes(for user: String) {
        var pathToSave = Utils.pathInDocument(with: user)
        if !FileManager.default.fileExists(atPath: pathToSave.path) {
            do {
                try FileManager.default.createDirectory(at: pathToSave, withIntermediateDirectories: true)
                print("Directory \(pathToSave) was created")
            } catch {
                print("Directory wasnt created")
            }
        }
        pathToSave.appendPathComponent(Utils.fileName)
        let success = NSKeyedArchiver.archiveRootObject(favMemesArray, toFile: pathToSave.path)
        if !success {
            debugPrint("Failed to save fav memes")
        }
    }
    
    func loadFavMemes(for user: String) {
        favMemesArray.removeAll()
        var pathToLoad = Utils.pathInDocument(with: user)
        pathToLoad.appendPathComponent(Utils.fileName)
        guard let arrayToLoad = NSKeyedUnarchiver.unarchiveObject(withFile: pathToLoad.path) as? [Meme] else {
            print("Loading from file failed")
            return
        }
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
                self.allMemesArray.removeAll()
                for jsonMeme in memesJSONArray {
                    guard let meme = Meme(json: jsonMeme) else { print("Meme hasn't been created"); continue }
                    //if !self.isPresentInArray(meme) {
                    self.allMemesArray.append(meme)
                    //}
                }
                NotificationCenter.default.post(name: .AllMemesLoaded, object: nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
