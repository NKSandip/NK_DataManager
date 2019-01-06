//
//  ProdcutReview.swift
//  MComm
//
//  Created by imac13 on 7/1/16.
//  Copyright © 2016 PerceptionSystem. All rights reserved.
//

import Foundation

open class ProductReview : NSObject {
    open var id : String
    open var title : String
    open var detail : String
    open var nickname : String
    open var customerId : String
    open var TotalOneStar : NSInteger
    open var TotalTwoStar : NSInteger
    open var TotalThreeStar : NSInteger
    open var TotalFourStar : NSInteger
    open var TotalFiveStar : NSInteger
    open var TotalRating : Float
    open var TotalReview : Float
    open var AvgRating : Float
    open var TotalVendorProductCount : NSInteger
    open var ratings : NSMutableArray = NSMutableArray()

    public init(data: NSDictionary){
        
        self.id = isNull(data["review_id"] as? String as AnyObject?) ? "" : data["review_id"] as! String
        self.title = isNull(data["title"] as? String as AnyObject?) ? "" : data["title"] as! String
        self.detail = isNull(data["detail"] as? String as AnyObject?) ? "" : data["detail"] as! String
        self.nickname = isNull(data["nickname"] as? String as AnyObject?) ? "" : data["nickname"] as! String
        self.customerId = isNull(data["customer_id"] as? String as AnyObject?) ? "" : data["customer_id"] as! String
        self.TotalOneStar = data["OneStarCount"] as! NSInteger
        self.TotalTwoStar = data["TwoStarCount"] as! NSInteger
        self.TotalThreeStar = data["ThreeStarCount"] as! NSInteger
        self.TotalFourStar = data["FourStarCount"] as! NSInteger
        self.TotalFiveStar = data["FiveStarCount"] as! NSInteger
        self.TotalVendorProductCount = isNull(data["VendorProductCount"] as? NSInteger as AnyObject?) ? 0 : data["VendorProductCount"] as! NSInteger
        self.TotalRating = data["TotalRating"] as! Float
        self.TotalReview = data["TotalReview"] as! Float
        self.AvgRating = data["AverageRating"] as! Float
        if let arrRating: NSArray = data["Items"] as? NSArray{
            if arrRating.count > 0 {
                for ratingDict in arrRating {
                    let objProduct: Rating = Rating.init(data: ratingDict as! NSDictionary)
                    ratings.add(objProduct)
                }
            }
        }
    }
}
