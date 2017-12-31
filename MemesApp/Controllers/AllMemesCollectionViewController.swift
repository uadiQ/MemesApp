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
import PKHUD

class AllMemesCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Meme"
        HUD.showProgressWithAutoHide(timeOutTime: 30)
        DataManager.instance.loadAllMemes()
        NotificationCenter.default.addObserver(self, selector: #selector(allMemesLoaded), name: .AllMemesLoaded, object: nil)

        // Register cell classes
        collectionView?.register(MemeCollectionViewCell.nib, forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
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
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension AllMemesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance.allMemesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID, for: indexPath) as? MemeCollectionViewCell else { fatalError("Cell with wrong id") }
        
        let meme = DataManager.instance.allMemesArray[indexPath.item]
        cell.update(meme: meme)
        return cell
    }
    
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.instance.addMeme(meme: DataManager.instance.allMemesArray[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Notifications
extension AllMemesCollectionViewController {
    @objc func allMemesLoaded() {
        HUD.hide()
        refreshData()
    }
}
