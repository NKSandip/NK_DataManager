//
//  Rating.swift
//  MComm
//
//  Created by imac13 on 7/1/16.
//  Copyright © 2016 PerceptionSystem. All rights reserved.
//

import Foundation

open class Rating : NSObject {
    open var voteID : String
    open  var percentage : String
    open var value : NSInteger
    open var ratingTitle : String
    open var ratingText : String
    open var customerName : String
    open var reviewDate : String
    
    public init(data: NSDictionary){

        self.voteID = isNull(data["CustomerId"] as? String as AnyObject?) ? "" : data["CustomerId"] as! String
        self.percentage = isNull(data["percentage"] as? String as AnyObject?) ? "" : data["percentage"] as! String
        self.value = data["Rating"] as! NSInteger
        self.ratingTitle = isNull(data["Title"] as? String as AnyObject?) ? "" : data["Title"] as! String
        self.ratingText = isNull(data["ReviewText"] as? String as AnyObject?) ? "" : data["ReviewText"] as! String
        self.customerName = isNull(data["CustomerName"] as? String as AnyObject?) ? "" : data["CustomerName"] as! String
        self.reviewDate = isNull(data["WrittenOnStr"] as? String as AnyObject?) ? "" : data["WrittenOnStr"] as! String
    }
}
