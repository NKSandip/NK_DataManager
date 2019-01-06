//
//  MLMUser.swift
//  MComm
//
//  Created by imac13 on 12/21/16.
//  Copyright © 2016 PerceptionSystem. All rights reserved.
//

import Foundation
import ImageIO

open class MLMUser : NSObject {
    open var parentId : NSInteger
    open var customerId : NSInteger
    open var name : String
    open var profileImage : String
    open var mlmLevel : NSInteger
    open var status : String
    open var countryName : String
    open var phoneNumber : String
    open var city : String
    open var memberText : String
    open var starBadge : NSInteger
    open var totalLikes : NSInteger
    open var isLike : Bool
    open var MermberId : String
    open var imageSize : CGSize

    public init(data: NSDictionary){

        let dictPicture = data["PictureInfo"] as! NSDictionary!

        self.parentId = isNull(data["ParentId"] as? NSInteger as AnyObject?) ? 0 : data["ParentId"] as! NSInteger
        self.customerId = data["CustomerId"] as! NSInteger
        self.mlmLevel = data["MLMLevel"] as! NSInteger
        self.name = isNull(data["Name"] as? String as AnyObject?) ? "" : data["Name"] as! String
        self.profileImage = isNull(dictPicture?["PictureUrl"] as? String as AnyObject?) ? "" : dictPicture?["PictureUrl"] as! String
        self.status = isNull(data["StatusLine"] as? String as AnyObject?) ? "" : data["StatusLine"] as! String
        self.countryName = isNull(data["CountryName"] as? String as AnyObject?) ? "" : data["CountryName"] as! String
        self.phoneNumber = isNull(data["PhoneNo"] as? String as AnyObject?) ? "" : data["PhoneNo"] as! String
        self.city = isNull(data["City"] as? String as AnyObject?) ? "" : data["City"] as! String
        self.memberText = isNull(data["MemberLevelInMyProfile"] as? String as AnyObject?) ? "" : data["MemberLevelInMyProfile"] as! String
        self.totalLikes = isNull(data["TotalLikes"] as? NSInteger as AnyObject?) ? 0 : data["TotalLikes"] as! NSInteger
        self.starBadge = isNull(data["CustomerStar"] as? NSInteger as AnyObject?) ? 0 : data["CustomerStar"] as! NSInteger
        self.MermberId = isNull(data["ReferralCode"] as? String as AnyObject?) ? "" : data["ReferralCode"] as! String
        self.isLike = data["Like"] as! Bool

        let picWidth = dictPicture?["PictureWidth"] as! NSString
        let picHeight = dictPicture?["PictureHeight"] as! NSString

        self.imageSize = CGSize(width: CGFloat(picWidth.floatValue), height: CGFloat(picHeight.floatValue))
    }

    func setImageSize(url:URL) -> Void {

        DispatchQueue.main.async {
            guard let imageSource = CGImageSourceCreateWithURL(URL.init(string:self.profileImage)! as CFURL, nil)
                , let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any]
                , let pixelWidth = imageProperties[kCGImagePropertyPixelWidth as String]
                , let pixelHeight = imageProperties[kCGImagePropertyPixelHeight as String]
                , let orientationNumber = imageProperties[kCGImagePropertyOrientation as String]
                else {

                    return
            }

            var width: CGFloat = 0, height: CGFloat = 0, orientation: Int = 0

            CFNumberGetValue(pixelWidth as! CFNumber, .cgFloatType, &width)
            CFNumberGetValue(pixelHeight as! CFNumber, .cgFloatType, &height)
            CFNumberGetValue(orientationNumber as! CFNumber, .intType, &orientation)

            // Check orientation and flip size if required
            if orientation > 4 { let temp = width; width = height; height = temp }
            
            self.imageSize = CGSize(width: width, height: height)
        }

    }
}
