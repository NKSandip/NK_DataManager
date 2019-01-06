//
//  NSDate+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension Date {
    
    // MARK:  NSDate Manipulation
    
    /**
        Returns a new NSDate object representing the date calculated by adding the amount specified to self date
    
        - parameter seconds: number of seconds to add
        - parameter minutes: number of minutes to add
        - parameter hours: number of hours to add
        - parameter days: number of days to add
        - parameter weeks: number of weeks to add
        - parameter months: number of months to add
        - parameter years: number of years to add
        - returns: the NSDate computed
    */
   public func add(_ seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> Date {
        let calendar = Calendar.current
    
        let version = floor(NSFoundationVersionNumber)
    
        if version <= NSFoundationVersionNumber10_9_2 {
            var component = DateComponents()
            (component as NSDateComponents).setValue(seconds, forComponent: .second)
            
            var date : Date! = (calendar as NSCalendar).date(byAdding: component, to: self, options: [])!
            component = DateComponents()
            (component as NSDateComponents).setValue(minutes, forComponent: .minute)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(hours, forComponent: .hour)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(days, forComponent: .day)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(weeks, forComponent: .weekOfMonth)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(months, forComponent: .month)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            
            component = DateComponents()
            (component as NSDateComponents).setValue(years, forComponent: .year)
            date = (calendar as NSCalendar).date(byAdding: component, to: date, options: [])!
            return date
        }
        
        var date : Date! = (calendar as NSCalendar).date(byAdding: .second, value: seconds, to: self, options: [])
        date = (calendar as NSCalendar).date(byAdding: .minute, value: minutes, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .day, value: days, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .hour, value: hours, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .weekOfMonth, value: weeks, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .month, value: months, to: date, options: [])
        date = (calendar as NSCalendar).date(byAdding: .year, value: years, to: date, options: [])
        return date
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of seconds to self date
    
        - parameter seconds: number of seconds to add
        - returns: the NSDate computed
    */
    public func addSeconds (_ seconds: Int) -> Date {
        return add(seconds)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of minutes to self date
    
        - parameter minutes: number of minutes to add
        - returns: the NSDate computed
    */
    public func addMinutes (_ minutes: Int) -> Date {
        return add(minutes: minutes)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of hours to self date
    
        - parameter hours: number of hours to add
        - returns: the NSDate computed
    */
    public func addHours(_ hours: Int) -> Date {
        return add(hours: hours)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of days to self date
    
        - parameter days: number of days to add
        - returns: the NSDate computed
    */
    public func addDays(_ days: Int) -> Date {
        return add(days: days)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of weeks to self date
    
        - parameter weeks: number of weeks to add
        - returns: the NSDate computed
    */
    public func addWeeks(_ weeks: Int) -> Date {
        return add(weeks: weeks)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of months to self date
    
        - parameter months: number of months to add
        - returns: the NSDate computed
    */
    public func addMonths(_ months: Int) -> Date {
        return add(months: months)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of years to self date
    
        - parameter years: number of year to add
        - returns: the NSDate computed
    */
    public func addYears(_ years: Int) -> Date {
        return add(years: years)
    }
    
    // MARK:- Class Functions
    /**
    Convert date from String
    
    - parameter dateStr: date String
    - parameter format:  date format
    
    - returns: Date object
    */
    public static func dateFromString(_ dateValue: String?, WithFormat format:inout String?) -> Date? {
        
        if dateValue == nil {
            return nil
        }
        if format == nil {
            format = Date.dateFormatDDMMYYYYDashed()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.date(from: dateValue!)
    }
}

extension Date: Strideable {
    /**
     Get Time interval between to Date
     
     - parameter other: Other Date
     
     - returns: time distance
     */
    public func distance(to other: Date) -> TimeInterval {
        return other - self
    }
    
    /**
     Get date by timeIntervalSinceReferenceDate
     
     - parameter n: time interval
     
     - returns: Date object
     */
    public func advanced(by n: TimeInterval) -> Date {
        return type(of: self).init(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
    }
}
