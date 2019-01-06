//
//  String+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
// MARK: - String Extension
extension String {
    
    /**
     String length
     */
    var length: Int { return self.characters.count }
    
    /**
     Reverse of string
     */
    var reverse: String { return String(self.characters.reversed()) }
    
    
    /**
     Get height of string
     
     - parameter width: Max width of string to calculate height
     - parameter font:  Font of string
     
     - returns: Height of string
 
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    */
    /**
     Get width of string
     
     - parameter width: Max width of string to calculate height
     - parameter font:  Font of string
     
     - returns: Height of string
 
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    */
    
    
    /**
     Get nsdata from string
     
     - returns: A NSdata from string
 
    func toData () -> Data {
        
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    */
    
    
    /**
     Returns an array of strings, each of which is a substring of self formed by splitting it on separator.
     
     - parameter separator: Character used to split the string
     - returns: Array of substrings
 
    func explode (_ separator: Character) -> [String] {
        
        return self.characters.split(whereSeparator: { (element: Character) -> Bool in
            return element == separator
        }).map { String($0) }
    }
    */
    /**
     Specify that string contains only letters.
     
     - returns: A Bool return true if only letters otherwise false.
     */
    func containsOnlyLetters () -> Bool {
        
        for chr in self.characters {
            if (!(chr >= "a" && chr <= "z") || !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    /**
     Specify that string contains only number.
     
     - returns: A Bool return true if string has only letters otherwise false.
     */
    func containOnlyNumber () -> Bool {
        
        let num = Int(self)
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
    
    /**
     Get array from string
     
     - parameter seperator: String to seperate array
     
     - returns: Array from string
     */
    func toArray (_ seperator: String) -> [String] {
        
        return self.components(separatedBy: seperator)
    }
    
    
    
    /**
     Get substring in string.
     
     - returns: A Bool return true if string has substring otherwise false.
     */
    func containsSubstring () -> Bool {
        
        return self.contains(self)
    }
    
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let utcDate = dateFormatter.date(from: self)
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        var localDateStr = ""
        if utcDate == nil {
          // do nothing
        } else {
            
            localDateStr = dateFormatter.string(from: utcDate!)
        }
        return localDateStr
    }
    
    func getCurrentDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let utcDate = dateFormatter.date(from: self)
        return utcDate!
        
    }
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let utcDate = dateFormatter.date(from: self)
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        var localDateStr = ""
        if utcDate == nil {
            // do nothing
        } else {
            
            localDateStr = dateFormatter.string(from: utcDate!)
        }
        return localDateStr
    }
    
    func convertToUTC() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        let localDate = dateFormatter.date(from: self)
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.string(from: localDate!)
        
        return date
    }
}
