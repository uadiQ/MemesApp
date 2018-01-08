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
    
}
