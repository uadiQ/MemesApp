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
