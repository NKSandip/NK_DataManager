//
//  NSData+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 04/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - NSData Extension
extension Data {
    
    func json() -> AnyObject? {
        
        var object: AnyObject?
        
        do {
            object = try JSONSerialization.jsonObject(with: self, options: []) as! [String:AnyObject] as AnyObject?
            // use anyObj here
        } catch {
            //LogManager.logDebug("json error: \(error)")
        }
        
        return object
    }
    
    /**
     Get base 64 strinf from nsdata
     
     - returns: A NSString
     */
    func toBase64EncodedString () -> String {
        
        return self.base64EncodedString(options: [NSData.Base64EncodingOptions()])
    }
}
