//
//  NSDate+Operators.swift
//  OnDemandApp
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: Arithmetic

func +(date: Date, timeInterval: Int) -> Date {
    return date + timeInterval
}

func -(date: Date, timeInterval: Int) -> Date {
    return date - timeInterval
}

func +=(date: inout Date, timeInterval: Int) {
    date = date + timeInterval
}

func -=(date: inout Date, timeInterval: Int) {
    date = date - timeInterval
}

func +(date: Date, timeInterval: Double) -> Date {
    return date.addingTimeInterval(TimeInterval(timeInterval))
}

func -(date: Date, timeInterval: Double) -> Date {
    return date.addingTimeInterval(TimeInterval(-timeInterval))
}

//func +=(date: inout Date, timeInterval: Double) {
//    date = date + timeInterval
//}
//
//func -=(date: inout Date, timeInterval: Double) {
//    date = date - timeInterval
//}

func -(date: Date, otherDate: Date) -> TimeInterval {
    return date.timeIntervalSince(otherDate)
}


public func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedSame
}


public func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == ComparisonResult.orderedAscending
}

