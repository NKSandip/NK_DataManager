//
//  UIStackView+Additions.swift
//  RvpMobile
//
//  Created by Rameshbhai Patel on 02/02/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

