//
//  AllMemesCollectionViewController.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 18.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllMemesCollectionViewController: UICollectionViewController {
    
    private var allMemesArray: [Meme] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Meme"
        loadMemes()
        NotificationCenter.default.addObserver(self, selector: #selector(allMemesLoaded), name: .AllMemesLoaded, object: nil)

        // Register cell classes
        collectionView?.register(MemeCollectionViewCell.nib, forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
    }
    
    private func loadMemes() {
        Alamofire.request("https://api.imgflip.com/get_memes").responseJSON { response in
            switch response.result {
            case .success(let value):
                //print(value)
                let jsonResponse = JSON(value)
                guard let memesJSONArray = jsonResponse["data"]["memes"].array else { fatalError("Didnt turn into array") }
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
    
    private func refreshData() {
        collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID, for: indexPath) as? MemeCollectionViewCell else { fatalError("Cell with wrong id") }
    
        let meme = allMemesArray[indexPath.item]
        cell.update(meme: meme)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
// MARK: - Notifications
extension AllMemesCollectionViewController {
    @objc func allMemesLoaded() {
        refreshData()
    }
}
