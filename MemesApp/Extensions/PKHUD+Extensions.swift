//
//  PKHUD+Extensions.swift
//  MemesApp
//
//  Created by Vadim Shoshin on 31.12.2017.
//  Copyright © 2017 Vadim Shoshin. All rights reserved.
//

import Foundation
import PKHUD

extension HUD {
    static func showProgressWithAutoHide(timeOutTime: TimeInterval ) {
        HUD.show(.progress)
        HUD.hide(afterDelay: timeOutTime)
    }
}
