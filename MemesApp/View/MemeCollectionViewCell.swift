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
    @IBOutlet private weak var ibMemeImage: UIImageView!
    @IBOutlet private weak var ibMemeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(meme: Meme) {
        ibMemeImage.image = #imageLiteral(resourceName: "placeholder")
        ibMemeTitle.text = meme.name
        self.ibMemeImage.af_setImage(withURL: meme.url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
}
