//
//  MemeCollectionViewCell.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 18.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MemeCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: MemeCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: MemeCollectionViewCell.self), bundle: nil)
    var image: UIImage = #imageLiteral(resourceName: "placeholder")
    @IBOutlet private weak var ibMemeImage: UIImageView!
    @IBOutlet private weak var ibMemeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(imageLoadedToCell), name: .ImageLoadedToCell, object: nil)
        ibMemeImage.image = #imageLiteral(resourceName: "placeholder")
    }

    func update(meme: Meme) {
        ibMemeTitle.text = meme.name
        Alamofire.request(meme.urlString).responseImage { response in
            guard let imageToLoad = response.value else { print("Couldn't load image"); return }
            self.image = imageToLoad
            NotificationCenter.default.post(name: .ImageLoadedToCell, object: nil)
        }
    }
}

extension MemeCollectionViewCell {
    @objc func imageLoadedToCell() {
        self.ibMemeImage.image = image
        self.layoutIfNeeded()
    }
}
