//
//  MemeDetailsViewController.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 24.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import UIKit
import AlamofireImage

class MemeDetailsViewController: UIViewController {
    @IBOutlet private weak var ibMemeImage: UIImageView!
    @IBOutlet private weak var ibMemeText: UILabel!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        guard let memeToLoad = meme else { return }
        ibMemeText.text = memeToLoad.name
        ibMemeImage.af_setImage(withURL: memeToLoad.url, placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }

    @IBAction func deletePressed(_ sender: Any) {
        DataManager.instance.deleteMeme(meme: meme!)
        navigationController?.popViewController(animated: true)
    }
    
}
