//
//  NSDate+Formatters.swift
//  OnDemandApp
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension Date {
    
    public static func dateFormatCCCCDDMMMYYYY() ->String {
        return "cccc, dd MMM yyyy"
    }
    public static func dateFormatCCCCDDMMMMYYYY() ->String {
        return "cccc, dd MMMM yyyy"
    }
    public static func dateFormatDDMMMYYYY() ->String {
        return "dd MMM yyyy"
    }
    public static func dateFormatDDMMYYYYDashed() ->String {
        return "dd-MM-yyyy"
    }
    public static func dateFormatDDMMYYYYSlashed() ->String {
        return "dd/MM/yyyy"
    }
    public static func dateFormatDDMMMYYYYSlashed() ->String {
        return "dd/MMM/yyyy"
    }
    public static func dateFormatMMMDDYYYY() ->String {
        return "MMM dd, yyyy"
    }
    public static func dateFormatYYYYMMDDDashed() ->String {
        return "yyyy-MM-dd"
    }
    
    public func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.dateFormatDDMMYYYYDashed()
        return formatter.string(from: self)
    }
    
    public func formattedStringUsingFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
