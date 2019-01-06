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
     Replace occurance of charater
     
     - parameter string: String which want to replace
     - parameter replacementString : New string at place of previous string
     - returns: Updated string after replacement
     */
    func replace(_ string: String, replacementString: String) -> String {
        
        return self.replacingOccurrences(of: string, with: replacementString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
     Replace occurance of space in string
     
     - returns: A String after remove white space
     */
    func removeWhitespaceInString() -> String {
        
        return self.replace(" ", replacementString: "")
    }
    
    func removeCharacterInCharacterSet(_ set: CharacterSet) -> String  {
        let tempArr = self.components(separatedBy: set)
        return tempArr.joined(separator: "")
        
    }
    
    /**
     Returns the substring in the given range
     
     - parameter range: specify the range to get string
     - returns: Substring in range
     */
    subscript (range: Range<Int>) -> String? {
        
        if range.lowerBound < 0 || range.upperBound > self.length {
            return nil
        }
        
        //        let range = Range(start: startIndex.advancedBy(range.startIndex), end: startIndex.advancedBy(range.endIndex))
        let range = characters.index(startIndex, offsetBy: range.lowerBound) ..< characters.index(startIndex, offsetBy: range.upperBound)
        return String(self[range])
    }
    
    /**
     Gets the character at the specified index as String.
     If index is negative it is assumed to be relative to the end of the String.
     
     - parameter index: Position of the character to get
     - returns: Character as String or nil if the index is out of bounds
     */
    subscript (i: Int) -> Character {
        
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    /**
     Takes a list of indexes and returns an Array containing the elements at the given indexes in self.
     
     - parameter indexes: Positions of the elements to get
     - returns: Array of characters (as String)
     */
    subscript (i: Int) -> String {
        
        return String(self[i] as Character)
    }
    
    /**
     Inserts a substring at the given index in self.
     
     - parameter index: Where the new string is inserted
     - parameter string: String to insert
     - returns: String formed from self inserting string at index
     */
    func insert (_ index: Int, _ string: String) -> String {
        
        //  Edge cases, prepend and append
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        
        return self[0..<index]! + string + self[index..<length]!
    }
    
    /**
     Strips the specified characters from the beginning of string.
     
     - parameter set: Give character set to apply on string for trimming
     
     - returns: A String trimmed after left whitespace
     */
    func trimmedLeft (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        if let range = rangeOfCharacter(from: set.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        
        return ""
    }
    
    @available (*, unavailable, message: "use 'trimmedLeft' instead") func ltrimmed (_ set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        return trimmedLeft(characterSet: set)
    }
    
    /**
     Strips the specified characters from the end of string.
     
     - parameter set: Give character set to apply on string for trimming
     
     - returns: A String trimmed after right whitespace
     */
    func trimmedRight (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        
        return ""
    }
    
    @available(*, unavailable, message: "use 'trimmedRight' instead") func rtrimmed (_ set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        return trimmedRight(characterSet: set)
    }
    
    /**
     Strips whitespaces from both the beginning and the end of string.
     
     - returns: A String after trimmed white space
     */
    func trimmed () -> String {
        
        return trimmedLeft().trimmedRight()
    }
    
    /**
     Parses a string containing a double numerical value into an optional double if the string is a well formed number.
     
     - returns: A double parsed from the string or nil if it cannot be parsed.
     */
    func toDouble () -> Double? {
        
        let scanner = Scanner(string: self)
        var double: Double = 0
        
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
    }
    
    /**
     Parses a string containing a float numerical value into an optional float if the string is a well formed number.
     
     - returns: A float parsed from the string or nil if it cannot be parsed.
     */
    func toFloat () -> Float? {
        
        let scanner = Scanner(string: self)
        var float: Float = 0
        
        if scanner.scanFloat(&float) {
            return float
        }
        
        return nil
    }
    
    /**
     Parses a string containing a non-negative integer value into an optional UInt if the string is a well formed number.
     
     - returns: A UInt parsed from the string or nil if it cannot be parsed.
     */
    func toUInt () -> UInt? {
        
        if let val = Int(self.trimmed()) {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    /**
     Parses a string containing a boolean value (true or false) into an optional Bool if the string is a well formed.
     
     - returns: A Bool parsed from the string or nil if it cannot be parsed as a boolean.
     */
    func toBool () -> Bool? {
        
        let text = self.trimmed().lowercased()
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }
        
        return nil
    }
    
    /**
     Parses a string containing a date into an optional NSDate if the string is a well formed.
     
     - parameter format: The default format is yyyy-MM-dd, but can be overriden.
     
     - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
     */
    func toDate (_ format : String? = "yyyy-MM-dd") -> Date? {
        
        let text = self.trimmed().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: text)
    }
    
    /**
     Parses a string containing a date and time into an optional NSDate if the string is a well formed.
     
     - parameter format: The default format is yyyy-MM-dd hh-mm-ss, but can be overriden.
     
     - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
     */
    func toDateTime (_ format : String? = "yyyy-MM-dd hh-mm-ss") -> Date? {
        
        return toDate(format)
    }
}
