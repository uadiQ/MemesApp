//
//  FavMemesCollectionViewController.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 18.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class FavMemesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        collectionView?.register(MemeCollectionViewCell.nib, forCellWithReuseIdentifier: MemeCollectionViewCell.reuseID)
        guard let emailToLoad = DataManager.instance.email else { return }
        DataManager.instance.loadFavMemes(for: emailToLoad)
        NotificationCenter.default.addObserver(self, selector: #selector(memeAdded), name: .MemeAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(memeDeleted), name: .MemeDeleted, object: nil)
        
    }
    
    func refreshData() {
        collectionView?.reloadData()
    }

    func getMeme(at indexPath: IndexPath) -> Meme {
        return DataManager.instance.favMemesArray[indexPath.item]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? MemeDetailsViewController else { return }
        destVC.meme = sender as? Meme
    }
    
    @IBAction func logoutPushed(_ sender: Any) {
        
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension FavMemesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.instance.favMemesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseID, for: indexPath) as? MemeCollectionViewCell else { fatalError("Cell with wrong id") }
        let meme = getMeme(at: indexPath)
        let memeName = meme.name
        let memeUrl = meme.url
        cell.update(memeName: memeName, memeUrl: memeUrl)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = getMeme(at: indexPath)
        performSegue(withIdentifier: "showDetails", sender: meme)
    }
}

// MARK: - Notifications
extension FavMemesCollectionViewController {
    @objc func memeAdded() {
        refreshData()
    }
    
    @objc func memeDeleted() {
        refreshData()
    }
}

extension FavMemesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    private var minItemSpacing: CGFloat { return 12 }
    
    private var sectionsInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
    }
    private var itemsPerRow: CGFloat { return 2 }
    
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
