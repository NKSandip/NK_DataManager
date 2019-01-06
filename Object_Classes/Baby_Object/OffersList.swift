//
//  OffersList.swift
//  Rytzee
//
//  Created by Nirav Shukla on 04/09/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit
enum OffersFilter: Int {
    //    RECOMMENDATIONS
    //    EXPLORE ALL
    //    MY FAVORITES
    //    MY OFFERS
    
    case recommendations = 1, explore = 2, favorites = 3, offers = 4
}


class OffersList: NSObject {
    public var offerID = 0
    public var service_id = 0
    public var has_offer_code = 0
    public var has_associated_service = 0
    public var is_favourite = 0
    
    public var title : String?
    public var descriptions : String?
    public var address : String?
    public var offer_image : String?
    public var terms : String?
    public var created_at : String?
    public var updated_at : String?
    
    public var firstPageUrl : String?
    public var lastPageUrl : String?
    public var nextPageUrl : String?
    public var path : String?
    public var prevPageUrl : String?
    
    public var paggination = 1
    public var currentPage = 0
    public var from = 0
    public var lastPage = 0
    public var perPage = 0
    public var to = 0
    public var total = 0
    
    
    var arrService : NSMutableArray = []
    var arrProm : NSMutableArray = []
    
    open class var sharedManager: OffersList {
        struct Static {
            static let instance: OffersList = OffersList()
        }
        return Static.instance
    }
    
    // MARK: Login User with Email
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        
        self.offerID = (addDict["id"] as? NSInteger)!
        self.service_id = (addDict["service_id"] as? NSInteger)!
        self.has_offer_code = (addDict["has_offer_code"] as? NSInteger)!
        self.has_associated_service = (addDict["has_associated_service"] as? NSInteger)!
        self.title = isNull(addDict["title"] as? String as AnyObject?) ? "" : addDict["title"] as! String
        self.descriptions = isNull(addDict["description"] as? String as AnyObject?) ? "" : addDict["description"] as! String
        self.address = isNull(addDict["address"] as? String as AnyObject?) ? "" : addDict["address"] as! String
        self.offer_image = isNull(addDict["offer_image"] as? String as AnyObject?) ? "" : addDict["offer_image"] as! String
        self.terms = isNull(addDict["terms"] as? String as AnyObject?) ? "" : addDict["terms"] as! String

        self.created_at = isNull(addDict["created_at"] as? String as AnyObject?) ? "" : addDict["created_at"] as! String
        self.updated_at = isNull(addDict["updated_at"] as? String as AnyObject?) ? "" : addDict["updated_at"] as! String
        
        self.is_favourite = (addDict["is_favourite"] as? NSInteger)!
        
        let serviceArray = addDict["service"] as! NSArray
        let promoArray = addDict["promo"] as! NSArray
        for dict in serviceArray {
            let objService : OffersServices = OffersServices().initWithDictionary(dict as! NSDictionary) as! OffersServices
            self.arrService.add(objService)
        }
        
        for dict in promoArray {
            let objPromo : OffersPromoList = OffersPromoList().initWithDictionary(dict as! NSDictionary) as! OffersPromoList
            self.arrProm.add(objPromo)
        }
        return self
    }
}

class OffersServices: NSObject {
    
    public var price : Double = 0
    public var is_favourite = 0
    
    public var title : String?
    public var currency : String?
    
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        if let myd:Double = addDict["price"] as? Double{
            self.price = myd
        }else if let myPrice : Int = addDict["price"] as? Int{
            self.price = Double(myPrice)
        }
        self.is_favourite = (addDict["is_favourite"] as? NSInteger)!

        self.title = isNull(addDict["title"] as? String as AnyObject?) ? "" : addDict["title"] as! String
        self.currency = isNull(addDict["currency"] as? String as AnyObject?) ? "" : addDict["currency"] as! String
        return self
    }
}

class OffersPromoList: NSObject {
    
    public var promoID = 0
    public var offer_ID = 0
    
    public var code : String?
    public var type : String?
    public var discount : String?
    public var expiry : String?
    
    public var createdAt : String?
    public var updatedAt : String?
    
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        self.promoID = (addDict["id"] as? NSInteger)!
        self.offer_ID = (addDict["offer_id"] as? NSInteger)!
        
        self.code = isNull(addDict["code"] as? String as AnyObject?) ? "" : addDict["code"] as! String
        self.type = isNull(addDict["type"] as? String as AnyObject?) ? "" : addDict["type"] as! String
        
        self.discount = isNull(addDict["discount"] as? String as AnyObject?) ? "" : addDict["discount"] as! String
        self.expiry = isNull(addDict["expiry"] as? String as AnyObject?) ? "" : addDict["expiry"] as! String
        
        self.createdAt = isNull(addDict["created_at"] as? String as AnyObject?) ? "" : addDict["created_at"] as! String
        self.updatedAt = isNull(addDict["updated_at"] as? String as AnyObject?) ? "" : addDict["updated_at"] as! String
        return self
    }
}
