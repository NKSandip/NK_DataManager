//
//  Cart.swift
//  MComm
//
//  Created by imac13 on 7/5/16.
//  Copyright © 2016 PerceptionSystem. All rights reserved.
//

import Foundation

open class CartProduct : NSObject {

   open  var productId :String!
   open var imageUrl :String!
   open var price :String!
   open var oldPrice :String!
   open var totalPrice :String!
   open var qty :NSInteger = 0
   open  var name :String!
   open  var itemID :NSInteger = 0
   open  var type :String!
   open var arrOption :NSMutableArray!
    public init(dict:NSDictionary){
        self.productId = isNull(dict["Id"] as? String as AnyObject?) ? "" : dict["Id"] as! String

        let dictImage: NSDictionary = (dict["DefaultPictureModel"] as? NSDictionary)!
        self.imageUrl = isNull(dictImage["ImageUrl"] as? String as AnyObject?) ? "" : dictImage["ImageUrl"] as! String

        self.qty = dict["Quantity"] as!NSInteger
        self.name = isNull(dict["Name"] as? String as AnyObject?) ? "" : dict["Name"] as! String
        self.itemID = dict["Id"] as!NSInteger
        self.type = isNull(dict["product_type"] as? String as AnyObject?) ? "" : dict["product_type"] as! String

         let dictPrice: NSDictionary = (dict["ProductPrice"] as? NSDictionary)!

        self.price = isNull(dictPrice["UnitPrice"] as? String as AnyObject?) ? "" : dictPrice["UnitPrice"] as! String
        self.totalPrice = isNull(dictPrice["SubTotal"] as? String as AnyObject?) ? "" : dictPrice["SubTotal"] as! String
        self.oldPrice = isNull(dictPrice["StrikeThroughPrice"] as? String as AnyObject?) ? "" : dictPrice["StrikeThroughPrice"] as! String
        let user : User = User.sharedManager
        user.cartBadgeCount += self.qty
        

        if let results: NSMutableArray = dict["options"] as? NSMutableArray{
            if results.count > 0 {
                self.arrOption = NSMutableArray()
                for dictOptions in results {
                    self.arrOption.add(dictOptions)
                }
            }
        }
    }

    open func updateCartQty(_ completion: @escaping (_ result: NSDictionary) -> Void){


        let strParam = String(format: "[{\"key\":\"UpdateCart\",\"Value\":\"Update Shopping Cart\"},{\"key\":\"itemquantity%d\",\"Value\":%d}]",self.itemID,self.qty)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/UpdateCart") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }
            else{
                let dict : NSDictionary = NSDictionary();
                completion(dict)

            }
        }
        
    }


    open func deleteFromCart(_ completion: @escaping (_ result: NSDictionary) -> Void){


        let strParam = String(format: "[{\"key\":\"UpdateCart\",\"Value\":\"Update Shopping Cart\"},{\"key\":\"RemoveFromCart\",\"Value\":%d}]",self.itemID)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/UpdateCart") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }
            else{
                let dict : NSDictionary = NSDictionary();
                completion(dict)
                
            }
        }
        
    }

}
