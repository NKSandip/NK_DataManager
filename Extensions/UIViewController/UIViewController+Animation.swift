//
//  UIViewController+Animation.swift
//  OnDemandApp
//  Created by Arvind Singh on 16/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func flipHorizontalViewContorller(_ viewController: UIViewController!, back:@escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.flipHorizontal, back: back)
    }
    
    func coverVerticalViewContorller(_ viewController: UIViewController!, back:@escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.coverVertical, back: back)
    }
    
    func crossDissolveViewContorller(_ viewController: UIViewController!, back:@escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.crossDissolve, back: back)
    }
    
    func partialCurlViewContorller(_ viewController: UIViewController!, back:@escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.partialCurl, back: back)
    }
    
    func showViewController(_ viewController: UIViewController!, modalTransitionStyle: UIModalTransitionStyle, back:@escaping () -> Void) {
        viewController.modalTransitionStyle = modalTransitionStyle
        self.present(viewController, animated: true, completion: back)
    }
}
