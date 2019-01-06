//
//  TrackingOrder.swift
//  MComm
//
//  Created by iMac9 on 26/05/17.
//  Copyright © 2017 PerceptionSystem. All rights reserved.
//

import UIKit
//"checkpoint_time" = "2017-05-01T15:34:42";
//city = "<null>";
//coordinates =                         (
//);
//"country_iso3" = IND;
//"country_name" = India;
//"created_at" = "2017-05-18T10:17:16+05:30";
//location = "Hisar (Haryana), India";
//message = "Dispatched - Out for delivery";
//slug = delhivery;
//state = "<null>";
//tag = OutForDelivery;
//zip = "<null>";

open class TrackingCheckPoints: NSObject {
    open var checkPointShippedBy : String!
    open var checkPointCreatedAt : String!
    open var checkPointLocation : String!
    open var checkPointCountryName : String!
    open var checkPointMessage : String!
    open var checkPointTag : String!
    open var checkPointCheckpointTime : String!
    
    public init(data: NSDictionary){
        self.checkPointShippedBy = isNull(data["slug"] as? String as AnyObject?) ? "" : data["slug"] as! String
        self.checkPointCreatedAt = isNull(data["created_at"] as? String as AnyObject?) ? "" : data["created_at"] as! String
        self.checkPointLocation = isNull(data["location"] as? String as AnyObject?) ? "" : data["location"] as! String
        self.checkPointCountryName = isNull(data["country_name"] as? String as AnyObject?) ? "" : data["country_name"] as! String
        self.checkPointMessage = isNull(data["message"] as? String as AnyObject?) ? "" : data["message"] as! String
        self.checkPointTag = isNull(data["tag"] as? String as AnyObject?) ? "" : data["tag"] as! String
        self.checkPointCheckpointTime = isNull(data["checkpoint_time"] as? String as AnyObject?) ? "" : data["checkpoint_time"] as! String
    }
}

open class TrackingOrder: NSObject {
    open var expectedDelivery : String!
    open var shippedStatus : String!
    open var shippedBy : String!
    
    open var trackedCount : NSInteger!
    open var deliveryTime : NSInteger!
    
    open var shipmentPickupDate : String!
    open var shipmentDeliveryDate : String!
    open var trackingNumber : String!
    
    open var arrTracking : NSMutableArray = NSMutableArray()
    public init(data: NSDictionary){
        
        let dictMain : NSDictionary = data["Data"] as! NSDictionary
        
        let dictData : NSDictionary = dictMain["data"] as! NSDictionary
        
        let dictTracking : NSDictionary = dictData["tracking"] as! NSDictionary
        
        self.expectedDelivery = isNull(dictTracking["expected_delivery"] as? String as AnyObject?) ? "" : dictTracking["expected_delivery"] as! String
        
        self.shippedStatus = isNull(dictTracking["tag"] as? String as AnyObject?) ? "" : dictTracking["tag"] as! String
        self.shippedBy = isNull(dictTracking["slug"] as? String as AnyObject?) ? "" : dictTracking["slug"] as! String
       
        self.trackedCount = isNull(dictTracking["tracked_count"] as? NSInteger as AnyObject?) ? 0 : dictTracking["tracked_count"] as! NSInteger
        
        self.deliveryTime = isNull(dictTracking["delivery_time"] as? NSInteger as AnyObject?) ? 0 : dictTracking["delivery_time"] as! NSInteger
        
        self.shipmentPickupDate = isNull(dictTracking["shipment_pickup_date"] as? String as AnyObject?) ? "" : dictTracking["shipment_pickup_date"] as! String
        
        self.shipmentDeliveryDate = isNull(dictTracking["shipment_delivery_date"] as? String as AnyObject?) ? "" : dictTracking["shipment_delivery_date"] as! String

        self.trackingNumber = isNull(dictTracking["tracking_number"] as? String as AnyObject?) ? "" : dictTracking["tracking_number"] as! String
        
        let responseData :NSArray = dictTracking["checkpoints"]! as! NSArray;
        if responseData.count > 0 {
            for catDict in responseData {
                let objTracking: TrackingCheckPoints = TrackingCheckPoints.init(data: catDict as! NSDictionary)
                arrTracking.add(objTracking)
            }
        }
        
    }
    open func getOrderItemTrackingDetails(itemID:NSInteger,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "AfterShip/ShipmentTrackingStatus/%d",itemID)
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                completion(responseDict!)
            }
                
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }
}
