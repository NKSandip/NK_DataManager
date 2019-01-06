//
//  String+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
// MARK: - String Extension
extension String {
    
    public func getShortDay (weakDay : String) -> String {
        if weakDay == "2" {
            return "MON"
        }else if weakDay == "3" {
            return "TUE"
        }else if weakDay == "4" {
            return "WED"
        }else if weakDay == "5" {
            return "THR"
        }else if weakDay == "6" {
            return "FRI"
        }else if weakDay == "7" {
            return "SAT"
        }
        return "SUN"
    }
}

