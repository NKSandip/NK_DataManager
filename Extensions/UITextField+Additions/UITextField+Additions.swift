//
//  UITextField+Additions.swift
//  OnDemandApp
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextField Extension
extension UITextField {
    
    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let font = self.font {
            
            let screenRatio = (UIScreen.main.bounds.size.width / 375)
            let fontSize = font.pointSize * screenRatio
            
            self.font = UIFont(name: font.fontName, size: fontSize)!
        }
    }
    
    func isTextFieldEmpty() -> Bool {
        
        if let value = self.text /*self.textByTrimmingWhiteSpacesAndNewline()*/ {
            return (value.length == 0)
        }
        return true
    }
    
    func textByTrimmingWhiteSpacesAndNewline() -> String {
        
        self.trimWhiteSpacesAndNewline()
        
        guard let _ = self.text else {
            return ""
        }
        return self.text!
    }
    
    func trimWhiteSpacesAndNewline() {
        let whitespaceAndNewline: CharacterSet = CharacterSet.whitespacesAndNewlines
        let trimmedString: String? = self.text?.trimmingCharacters(in: whitespaceAndNewline)
        self.text = trimmedString
    }

    
    // MARK: Control Actions
    @IBAction func toggleSecureText() {
        self.isSecureTextEntry = !self.isSecureTextEntry
        let tmpString = self.text
        self.text = ""
        self.text = tmpString
    }
    
    //Method to provide spacing between characters
    
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }
}
