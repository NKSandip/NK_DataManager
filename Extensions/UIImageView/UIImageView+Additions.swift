//
//  UIImageView+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
private let kFontResizingProportion = 0.42

// MARK: - UIImageView Extension
extension UIImageView {
    /**
     change image tint color
     - returns : new UIImage with custom color
     */
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
