//
//  AllMemes+Extension.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 08.01.2018.
//  Copyright © 2018 Vadim Shoshin. All rights reserved.
//

import UIKit
import PKHUD

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataManager.instance.addMeme(meme: DataManager.instance.allMemesArray[indexPath.item])
        
        
        
        ///////////// FILEMANAGER TESTING
        guard let email = DataManager.instance.email else { return }
        DataManager.instance.saveFavMemes(for: email)
        //////////////////////
        
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
