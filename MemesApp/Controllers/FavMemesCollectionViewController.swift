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
        NotificationCenter.default.addObserver(self, selector: #selector(memeAdded), name: .MemeAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(memeDeleted), name: .MemeDeleted, object: nil)
    }
    
    private func refreshData() {
        collectionView?.reloadData()
    }

    private func getMeme(at indexPath: IndexPath) -> Meme {
        return DataManager.instance.favMemesArray[indexPath.item]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? MemeDetailsViewController else { return }
        destVC.meme = sender as? Meme
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
        cell.update(meme: meme)
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
