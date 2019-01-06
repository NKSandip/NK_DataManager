//
//  UIButton+Additions.swift
//  OnDemandApp
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIButton Extension
extension UIButton {
    
    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let font = self.titleLabel?.font {
            
         let screenRatio = (UIScreen.main.bounds.size.width / 375)
            let fontSize = font.pointSize * screenRatio
            
            self.titleLabel!.font = UIFont(name: font.fontName, size: fontSize)!
        }
    }
    
    /**
     Make underline title
     */
    func underlineTitle() {
        
        if let buttonTitle = self.titleLabel?.text {
            let range = NSMakeRange(0, buttonTitle.length)
            underlineTitle(range)
        }
    }
    
    func underlineTitle(_ range: NSRange) {
        
        if let buttonTitle = self.titleLabel?.text {
            let titleString : NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)
            titleString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            self.setAttributedTitle(titleString, for: UIControlState())
        }
    }
    
    func underlineTextInTitle(_ text: String) {
        underlineTextsInTitle(text)
    }
    
    func underlineTextsInTitle(_ texts: String...) {
        
        if let buttonTitle = self.titleLabel?.text {
            let titleString : NSMutableAttributedString = NSMutableAttributedString(string: buttonTitle)
            
            for text in texts {
                let range = (buttonTitle as NSString).range(of: text)
                titleString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
            }
            
            self.setAttributedTitle(titleString, for: UIControlState())
        }
    }

}

extension UIButton {
    
    func setTitleWithoutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, for: .normal)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    
    func addLocalization() -> Void {
        
        /*let title = self.title(for: .normal)
        self.setTitle(addLocalization(title!), for: .normal)
        self.titleLabel?.addTextSpacing(spacing: 1.0)
        if Localisator.sharedInstance.currentLanguage == "ar" {
            self.titleLabel?.font = UIFont(name: "GeezaPro-Bold", size: (self.titleLabel?.font.pointSize)!)
        }
        */
    }
}
