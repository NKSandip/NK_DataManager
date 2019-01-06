//
//  Order.swift
//  MComm
//
//  Created by imac13 on 6/29/16.
//  Copyright © 2016 Aamir . All rights reserved.
//

import UIKit

open class Order: NSObject {

    open  var orderID : NSInteger
    open  var createdDate : String!
    open  var status : String!
    open  var paymentStatus : String!
    open  var shippingStatus : String!
    open  var grandTotal : String!
    
    public init(data: NSDictionary){
        self.orderID =  (data["Id"] as? NSInteger)!
        self.createdDate = isNull(data["CreatedOn"] as? String as AnyObject?) ? "" : data["CreatedOn"] as! String
        self.status = isNull(data["OrderStatus"] as? String as AnyObject?) ? "" : data["OrderStatus"] as! String
        self.paymentStatus = isNull(data["PaymentStatus"] as? String as AnyObject?) ? "" : data["PaymentStatus"] as! String
        self.shippingStatus = isNull(data["ShippingStatus"] as? String as AnyObject?) ? "" : data["ShippingStatus"] as! String
        self.grandTotal = isNull(data["OrderTotal"] as? String as AnyObject?) ? "" : data["OrderTotal"] as! String
    }


    open func getOrderDetails(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        let strProduct = String(format: "order/details/%d", self.orderID)
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                /* let arrResponse : NSMutableArray = NSMutableArray()
                let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                print("responseData : ",responseData)
                if let arrOptions: NSArray = responseData["Items"] as? NSArray{
                    print("arrOptions : ",arrOptions)
                    if arrOptions.count > 0 {
                        for proDict in arrOptions {
                            let objPro: Product = Product.init(data: proDict as! NSDictionary)
                            print("objPro : ",objPro)
                            arrResponse.add(objPro)
                        }
                        responseDict?.setValue(arrResponse, forKey: "Items")
                    }
                }*/
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
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
    
    //order/cancelorder/456
    open func cancelOrderDetails(itemID:NSInteger,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "order/cancelorder/%d",itemID)
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
    
    
    //order/returnrequests
    open func getReturnsRequestList(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "order/returnrequests")
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    open func applyforReturnRequest(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        let resonId : String = data["ReturnRequestReasonId"]as! String
        let comments : String = data["Comments"]as! String
        let orderId : String = data["OrderId"] as! String
        let itemsList : NSMutableArray = data["items"]as! NSMutableArray
        
        let strDownload : NSMutableString = ""
        for item in itemsList {
            let dict : NSDictionary = item as! NSDictionary
            let title = String(dict["Id"] as! Int)
            let type = String(dict["Quantity"] as! Int)
            strDownload.append(String(format:"{\"Id\":%@,\"Quantity\":%@},",title,type))
        }
        let range :NSRange = NSMakeRange(strDownload.length-1, 1)
        strDownload.deleteCharacters(in: range)        
        let strParam = String(format: "{\"OrderId\":%@,\"items\":[%@],\"ReturnRequestReasonId\":%@,\"Comments\":\"%@\"}", orderId,strDownload,resonId,comments)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("order/returnrequest/add") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }
            else{
                
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }
}
