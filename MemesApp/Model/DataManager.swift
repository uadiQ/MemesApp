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
    private init() { email = keychain.get(Keys.email) }
    
    private(set) var email: String?
    private(set) var allMemesArray: [Meme] = []
    private(set) var favMemesArray: [Meme] = []
    let keychain = KeychainSwift()
    
    func setEmail(with email: String) {
        self.email = email
        keychain.set(email, forKey: Keys.email)
    }
    
    func deleteEmail() {
        keychain.delete(Keys.email)
    }
    
    func addMeme(meme: Meme) {
        favMemesArray.append(meme)
        guard let emailToSave = email else {debugPrint("no email to save to"); return }
        saveFavMemes(for: emailToSave)
        NotificationCenter.default.post(name: .MemeAdded, object: nil)
    }
    
    func deleteMeme(at index: Int) {
        favMemesArray.remove(at: index)
        
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
         let success = NSKeyedArchiver.archiveRootObject([favMemesArray], toFile: String(describing: pathToSave))
         if !success {
         debugPrint("Failed to save fav memes")
         }
         //        (favMemesArray as NSArray).write(to: documentsUrl, atomically: true)
         //        print("File was saved")
 
        /*
        guard let emailToSave = email else { print("no email to save to"); return }
        let dataBlob = NSKeyedArchiver.archivedData(withRootObject: favMemesArray)
        UserDefaults.standard.set(dataBlob, forKey: emailToSave)
        UserDefaults.standard.synchronize()
        */
    }
    
    func loadFavMemes(for user: String) {
        
         var pathToLoad = Utils.pathInDocument(with: user)
         pathToLoad.appendPathComponent(Utils.fileName)
         guard let arrayToLoad = NSKeyedUnarchiver.unarchiveObject(withFile: String(describing: pathToLoad)) as? [Meme] else {print( "failed to load fav memes from file"); return}
         setFavMemesArray(with: arrayToLoad)
 
        /*
        guard let emailToLoad = email else { return }
        guard let decodedDataBlob = UserDefaults.standard.object(forKey: emailToLoad) as? Data else { print("no data loaded"); return }
        guard let loadedMemesFromUserDefault = NSKeyedUnarchiver.unarchiveObject(with: decodedDataBlob) as? [Meme] else {print("no memes loaded"); return }
        
        setFavMemesArray(with: loadedMemesFromUserDefault)
        */
    }
    
    func setFavMemesArray(with array: [Meme]) {
        favMemesArray.removeAll()
        favMemesArray = array
    }
    
//    func isPresentInArray(_ meme: Meme) -> Bool {
//        for item in allMemesArray where meme.id == item.id {
//            return true
//        }
//        return false
//    }
    
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
