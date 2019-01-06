//
//  UITextView+Additions.swift
//  OnDemandApp
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextView Extension
extension UITextView {
    
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
    
    func resolveHashTags() {
        
        // turn string in to NSString
        let nsText:NSString = self.text as NSString
        
        // this needs to be an array of NSString.  String does not work.
        let words:[String] = nsText.components(separatedBy: " ")
        
        // you can't set the font size in the storyboard anymore, since it gets overridden here.
        let attrs = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17.0)
        ]
        
        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        
        // tag each word if it has a hashtag
        for word in words {
            
            // found a word that is prepended by a hashtag!
            // we can implement @mentions here too.
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                
                // convert the word from NSString to String
                // this allows us to call "dropFirst" to remove the hashtag
                var stringifiedWord:String = word as String
                
                // drop the hashtag
                stringifiedWord = String(stringifiedWord.characters.dropFirst())
                
                // check to see if the hashtag has numbers.
                // ribl is "#1" shouldn't be considered a hashtag.
                let digits = CharacterSet.decimalDigits
                
                if let _ = stringifiedWord.rangeOfCharacter(from: digits) {
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    attrString.addAttribute(NSAttributedStringKey.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }
            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
    }
}
