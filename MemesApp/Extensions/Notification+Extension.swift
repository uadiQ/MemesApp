//
//  Notification+Extension.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 18.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let MemeAdded = Notification.Name("MemeAdded")
    static let MemeDeleted = Notification.Name("MemeDeleted")
    static let AllMemesLoaded = Notification.Name("AllMemesLoaded")
    static let ImageLoadedToCell = Notification.Name("ImageLoadedToCell")
}
