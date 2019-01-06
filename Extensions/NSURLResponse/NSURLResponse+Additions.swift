//
//  NSURLResponse+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 04/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
// MARK: - NSURLResponse Extension
extension URLResponse {
    
    func isHTTPResponseValid() -> Bool {
        
        if let response = self as? HTTPURLResponse {
            return (response.statusCode >= 200 && response.statusCode <= 299)
        }
        return false
    }
}
