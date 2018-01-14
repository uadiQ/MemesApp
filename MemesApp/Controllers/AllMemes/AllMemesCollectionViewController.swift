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
    
   func refreshData() {
        collectionView?.reloadData()
    }
}

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
        let memeName = meme.name
        let memeUrl = meme.url
        cell.update(memeName: memeName, memeUrl: memeUrl)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.instance.addMeme(meme: DataManager.instance.allMemesArray[indexPath.item])
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UICollectionViewLayout
extension AllMemesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    private var minItemSpacing: CGFloat { return 12 }
    
    private var sectionsInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    }
    private var itemsPerRow: CGFloat { return 3 }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = minItemSpacing * (itemsPerRow - 1) + sectionsInsets.left + sectionsInsets.right
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInsets
    }
    
}

// MARK: - Notifications
extension AllMemesCollectionViewController {
    @objc func allMemesLoaded() {
        HUD.hide()
        refreshData()
    }
}
