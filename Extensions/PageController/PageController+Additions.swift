//
//  PageController+Additions.swift
//  Rytzee
//
//  Created by Nirav Shukla on 24/07/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

// MARK: - UIPageControl Extension

extension UIPageControl {
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderWidth = dotBorderWidth
            }else{
                dotView.backgroundColor = .white
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}
