//
//  Product.swift
//  PSKit
//
//  Created by Aamir  on 6/22/16.
//  Copyright © 2016 Aamir . All rights reserved.
//

import Foundation

let simple = "simple"
let configurable = "configurable"
let downloadable = "downloadable"

open class SampleFile : NSObject{

    open var file : String
    open var name : String
    open var size : NSInteger
    open var status : String

    public init(data: NSDictionary){
        self.file = isNull(data["file"] as? String as AnyObject?) ? "" : data["file"] as! String
        self.name = isNull(data["name"] as? String as AnyObject?) ? "" : data["name"] as! String
        self.status = isNull(data["status"] as? String as AnyObject?) ? "" : data["status"] as! String
        self.size =  data["size"] as! NSInteger
    }
}

// A class stores downloadble object and links array to Product
open class Downloadable : NSObject{
    open var linkId : String
    open var title : String
    open var price : String
    open var noOfDownloads: String
    open var isSharable: String
    open var linkType : String
    open var sampleFilePath : String
    open var sampleURL : String
    open var sampleType : String
    open var arrSampleFiles : NSMutableArray!
    open var arrFiles : NSMutableArray!


    public init(data: NSDictionary){
        self.linkId = isNull(data["link_id"] as? String as AnyObject?) ? "" : data["link_id"] as! String
        self.title = isNull(data["title"] as? String as AnyObject?) ? "" : data["title"] as! String
        self.price = isNull(data["price"] as? String as AnyObject?) ? "" : data["price"] as! String
        self.noOfDownloads = isNull(data["number_of_downloads"] as? String as AnyObject?) ? "" : data["number_of_downloads"] as! String
        self.isSharable = isNull(data["is_shareable"] as? String as AnyObject?) ? "" : data["is_shareable"] as! String
        self.linkType = isNull(data["link_type"] as? String as AnyObject?) ? "" : data["link_type"] as! String
        self.sampleFilePath = isNull(data["sample_file"] as? String as AnyObject?) ? "" : data["sample_file"] as! String
        self.sampleURL = isNull(data["sample_url"] as? String as AnyObject?) ? "" : data["sample_url"] as! String
        self.sampleType = isNull(data["sample_type"] as? String as AnyObject?) ? "" : data["sample_type"] as! String

        if let arrFiles: NSArray = data["file_save"] as? NSArray{
            if arrFiles.count > 0 {
                self.arrFiles=NSMutableArray()
                for optDict in arrFiles {
                    let addtional : SampleFile = SampleFile.init(data: optDict as! NSDictionary)
                    self.arrFiles.add(addtional)
                }
            }
        }

        if let arrSampleFiles: NSArray = data["sample_file_save"] as? NSArray{
            if arrSampleFiles.count > 0 {
                self.arrSampleFiles=NSMutableArray()
                for optDict in arrSampleFiles {
                    let addtional : SampleFile = SampleFile.init(data: optDict as! NSDictionary)
                    self.arrSampleFiles.add(addtional)
                }
            }
        }
    }

}

/*{
    "Id": 19,
    "Name": "8",
    "ColorSquaresRgb": null,
    "PriceAdjustment": "+$2.00",
    "PriceAdjustmentValue": 2,
    "IsPreSelected": false,
    "PictureModel": {
        "ImageUrl": null
    }
},*/

open class AdditionalFields : NSObject {
    open var valueId : NSInteger
    open var name : String
    open var price : String
    open var price_type: String
    open var isPreSelected: Bool


    public init(data: NSDictionary){

        self.valueId = (data["Id"] as? NSInteger )!
        self.isPreSelected = (data["IsPreSelected"] as? Bool )!
        self.name = isNull(data["Name"] as? String as AnyObject?) ? "" : data["Name"] as! String
        self.price = isNull(data["PriceAdjustment"] as? String as AnyObject?) ? "" : data["PriceAdjustment"] as! String
        self.price_type = isNull(data["price_type"] as? String as AnyObject?) ? "" : data["price_type"] as! String

    }

}
open class Options : NSObject {
   open var title:String
   open var type:String
   open var is_require: String
   open var sort_type:String
   open var additionalFields:[AdditionalFields] = []

    public init(data: NSDictionary){

        self.title = isNull(data["title"] as? String as AnyObject?) ? "" : data["title"] as! String
        self.type = isNull(data["type"] as? String as AnyObject?) ? "" : data["type"] as! String
        self.is_require = isNull(data["is_require"] as? String as AnyObject?) ? "" : data["is_require"] as! String
        self.sort_type = isNull(data["sort_order"] as? String as AnyObject?) ? "" : data["sort_order"] as! String
        if let arrAddtional: NSArray = data["additional_fields"] as? NSArray{
            if arrAddtional.count > 0 {
                for optDict in arrAddtional {
                    let addtional : AdditionalFields = AdditionalFields.init(data: optDict as! NSDictionary)
                    self.additionalFields.append(addtional)
                }
            }
        }
    }
}

/*"Id": 8,
"ProductId": 25,
"ProductAttributeId": 7,
"Name": "Size",
"Description": null,
"TextPrompt": null,
"IsRequired": true,*/

open class CustomOptions : NSObject {
    open var optionId : NSInteger
    open var productId : NSInteger
    open var productAttributeId : NSInteger
    open var name : String
    open var isRequired : Bool
    open var options : Options?
    open var selectedFiled : AdditionalFields?
    open var arrValues : NSMutableArray = NSMutableArray()

    public init(data: NSDictionary){

        self.optionId = (data["Id"] as? NSInteger)!
        self.productId = (data["ProductId"] as? NSInteger)!
        self.productAttributeId = (data["ProductAttributeId"] as? NSInteger)!
        self.isRequired = (data["IsRequired"] as? Bool)!
        self.name = isNull(data["Name"] as? String as AnyObject?) ? "" : data["Name"] as! String

        if let arrAddtional: NSArray = data["Values"] as? NSArray{
            if arrAddtional.count > 0 {
                for optDict in arrAddtional {
                    let addtional : AdditionalFields = AdditionalFields.init(data: optDict as! NSDictionary)
                    self.arrValues.add(addtional)
                }
            }
        }
    }
}

open class ConfigurableOptions : NSObject{
    open var valueId, label, price, oldPrice, StrikeThroughPrice : String
    open var products = [String]()

    public init(data: NSDictionary){
        self.valueId = data["id"] as! String
        self.label = data["label"] as! String
        self.price = data["price"] as! String
        self.StrikeThroughPrice = data["StrikeThroughPrice"] as! String
        self.oldPrice = data["oldPrice"] as! String
        self.products = data["products"] as! NSArray as! [String]
    }
}

open class Configurables : NSObject{
    open var optionId, code, label : String
    open var options : [ConfigurableOptions] = []
    public init(data: NSDictionary){
        self.optionId = data["id"] as! String
        self.code = data["code"] as! String
        self.label = data["code"] as! String
        let dictOptions: NSArray = data["options"] as! NSArray

        for dict in dictOptions {
            let innerOption : ConfigurableOptions = ConfigurableOptions.init(data: dict as! NSDictionary)
            self.options.append(innerOption)
        }

    }
}

open class Product : NSObject {
    open var id : NSInteger
    open var ShoppingCartid : NSInteger
    open var qty : String
    open var AttributeInfo : String
    open var cartQty : NSInteger
    open var totalViews : NSInteger = 0
    open var ShippingCharge : String?
    open var addtionalShipCharge : String?
    open var dummyShippingCharge : String?
    open var deliveryDays : String
    open var sizeChartUrl : String?
    open var sku : String
    open var name : String
    open var totalRating : Float
    open var totalReview : Float
    open var typeId : String
    open var fullDesc : String
    open var shortDesc : String
    open var refundPolicy : String
    open var price : String
    open var StrikeThroughPrice : String
    open var url : String
    open var addToCarturl : String
    open var productImageWidth : String
    open var productImageHeight : String
//    open var productImageSize : CGSize
    open var specialPrice : String
    open var specialImageURL : String
    open var inStock : String
    open var wishListId : NSInteger
    open var liveDemoUrl : String
    open var liveDemoBackendUrl : String
    open var images : NSMutableArray = NSMutableArray()
    open var customOptions:NSMutableArray = NSMutableArray()
    open var configurableOptions:[Configurables] = []
    open var arrSelectedConfigurable = [NSMutableDictionary]()
    open var arrSelectedCustomOptions = [AdditionalFields]()
    open var arrDownloadable = [Downloadable]()
    open var arrSelectedDownloadable = [Downloadable]()
    open var showVendor : Bool = false
    open var isWishList : Bool = false
    open var CodAvailable : Bool = false
    open var isFreeShiping : Bool = false
    open var isIndianProduct : Bool = false
    open var vendorID : NSInteger = 0
    open var vendorName : String?
    open var productDiscount : String?
    open var CountryFlag : String?
    open var ProductCountryName : String?
    open var arrSelectedOptions: NSMutableArray = NSMutableArray()
    open var isAliExpressProduct : Bool = false

    
    
    open var reviews : NSMutableArray = NSMutableArray()
    
    public init(data: NSDictionary){
        
        let dictProductPrice : NSDictionary = data["ProductPrice"] as! NSDictionary
        
        let dictReviewOverviewModel : NSDictionary = data["ReviewOverviewModel"] as! NSDictionary
        
        let dictPictureModel : NSDictionary = data["DefaultPictureModel"] as! NSDictionary
        
        let dictPicture = data["PictureInfo"] as! NSDictionary!

        let dictVendor : NSDictionary = data["VendorModel"] as! NSDictionary
        self.vendorName = isNull(dictVendor["Name"] as? String as AnyObject?) ? "" : dictVendor["Name"] as! String
        self.vendorID = (dictVendor["Id"] as? NSInteger)!//VendorId
        
        self.CountryFlag = isNull(data["CountryFlag"] as? String as AnyObject?) ? "" : data["CountryFlag"] as! String
        self.ProductCountryName = isNull(data["CountryName"] as? String as AnyObject?) ? "" : data["CountryName"] as! String
        
        self.id = (data["Id"] as? NSInteger)!
        self.sku = isNull(data["sku"] as? String as AnyObject?) ? "" : data["sku"] as! String
        self.qty = isNull(data["qty"] as? String as AnyObject?) ? "" : data["qty"] as! String
        self.cartQty = (data["Quantity"] as? NSInteger)!
        self.name = isNull(data["Name"] as? String as AnyObject?) ? "" : data["Name"] as! String
        self.AttributeInfo = isNull(data["AttributeInfo"] as? String as AnyObject?) ? "" : data["AttributeInfo"] as! String

        self.isAliExpressProduct = (data["IsAliExpressProduct"] as? Bool)!
        
        self.totalRating = (dictReviewOverviewModel["RatingSum"] as? Float)!
        self.totalReview = (dictReviewOverviewModel["TotalReviews"] as? Float)!
        self.typeId = isNull(data["type_id"] as? String as AnyObject?) ? "" : data["type_id"] as! String
        self.fullDesc = isNull(data["description"] as? String as AnyObject?) ? "" : data["description"] as! String
        self.shortDesc = isNull(data["ShortDescription"] as? String as AnyObject?) ? "" : data["ShortDescription"] as! String
        self.deliveryDays = isNull(data["DeliveryDays"] as? String as AnyObject?) ? "" : data["DeliveryDays"] as! String

        self.refundPolicy = isNull(data["RefundPolicy"] as? String as AnyObject?) ? "" : data["RefundPolicy"] as! String
        self.price = isNull(dictProductPrice["UnitPrice"] as? String as AnyObject?) ? "" : dictProductPrice["UnitPrice"] as! String
        self.StrikeThroughPrice = isNull(dictProductPrice["StrikeThroughPrice"] as? String as AnyObject?) ? "" : dictProductPrice["StrikeThroughPrice"] as! String
        
        self.specialPrice = isNull(dictProductPrice["Price"] as? String as AnyObject?) ? "" : dictProductPrice["Price"] as! String
        
        self.specialImageURL = isNull(dictProductPrice["PictureUrl"] as? String as AnyObject?) ? "" : dictProductPrice["PictureUrl"] as! String
        
        self.inStock = isNull(data["is_in_stock"] as? String as AnyObject?) ? "" : data["is_in_stock"] as! String
        
        self.wishListId =  (data["WishlistId"] as? NSInteger)!
        self.ShoppingCartid =  (data["ShoppingCartId"] as? NSInteger)!
        
        let dictProduct : NSDictionary = data["ProductPrice"] as! NSDictionary

        self.productDiscount =  isNull(dictProduct["ProductDiscount"] as? String as AnyObject?) ? "" : dictProduct["ProductDiscount"] as! String

        self.addToCarturl = isNull(dictPictureModel["ImageUrl"] as? String as AnyObject?) ? "" : dictPictureModel["ImageUrl"] as! String
        
        self.url = isNull(dictPicture?["PictureUrl"] as? String as AnyObject?) ? "" : dictPicture?["PictureUrl"] as! String
        
        self.productImageWidth = isNull(dictPicture?["PictureWidth"] as? String as AnyObject?) ? "" : dictPicture?["PictureWidth"] as! String
        self.productImageHeight = isNull(dictPicture?["PictureHeight"] as? String as AnyObject?) ? "" : dictPicture?["PictureHeight"] as! String
        
        self.liveDemoUrl = isNull(data["livedemo"] as? String as AnyObject?) ? "" : data["livedemo"] as! String
        self.liveDemoBackendUrl = isNull(data["livedemo_backend"] as? String as AnyObject?) ? "" : data["livedemo_backend"] as! String
        if let results: NSArray = data["images"] as? NSArray{
            if results.count > 0 {
                for imgDict in results {
                    let image : Images = Images.init(data: imgDict as! NSDictionary)
                    self.images.add(image)
                }
            }
        }
        
        if let arrOptions: NSArray = data["custom_options"] as? NSArray{
            if arrOptions.count > 0 {
                for optDict in arrOptions {
                    let option : CustomOptions = CustomOptions.init(data:optDict as! NSDictionary)
                    
                    self.customOptions.add(option)
                    
                }
            }
        }
        
        ///Read configurable data
        if(self.typeId.localizedCaseInsensitiveCompare("configurable") == ComparisonResult.orderedSame){
            
            if let arrOptions: NSArray = data["configurable_options"] as? NSArray{
                if arrOptions.count > 0 {
                    for optDict in arrOptions {
                        let option : Configurables = Configurables.init(data:optDict as! NSDictionary)
                        self.configurableOptions.append(option);
                    }
                }
            }
        }
        
        if(self.typeId.localizedCaseInsensitiveCompare("downloadable") == ComparisonResult.orderedSame){
            
            if let arrOptions: NSArray = data["downloadable_links"] as? NSArray{
                if arrOptions.count > 0 {
                    for optDict in arrOptions {
                        let option : Downloadable = Downloadable.init(data:optDict as! NSDictionary)
                        self.arrDownloadable.append(option);
                    }
                }
            }
        }
    }
    
    open func isOptionSelected()->Bool{
        for objOption in self.customOptions {
            if (objOption as AnyObject).selectedFiled==nil {
                return false;
            }
        }
        return true;
    }
    
    open func getProductDetails(_completion: @escaping (_ isDetails:Bool) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "productdetails/%d", self.id)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                let arrImages : NSArray = responseData["PictureDetailList"] as! NSArray//PictureModels
                self.images = NSMutableArray.init(array: arrImages)
                self.fullDesc = isNull(responseData["FullDescription"] as? String as AnyObject?) ? "" : responseData["FullDescription"] as! String
                self.shortDesc = isNull(responseData["ShortDescription"] as? String as AnyObject?) ? "" : responseData["ShortDescription"] as! String
                self.refundPolicy = isNull(responseData["RefundPolicy"] as? String as AnyObject?) ? "" : responseData["RefundPolicy"] as! String
                self.wishListId =  (responseData["WishlistId"] as? NSInteger)!
                
                let dictVendor : NSDictionary = responseData["VendorModel"] as! NSDictionary
                self.vendorName = isNull(dictVendor["Name"] as? String as AnyObject?) ? "" : dictVendor["Name"] as! String
                self.vendorID = (dictVendor["VendorId"] as? NSInteger)!
                self.showVendor = (responseData["ShowVendor"] as? Bool)!
                self.isWishList = (responseData["IsWishlist"] as? Bool)!
                self.isFreeShiping = (responseData["IsFreeShipping"] as? Bool)!
                self.CodAvailable = (responseData["CodAvailable"] as? Bool)!
                self.isIndianProduct = (responseData["IsIndianProduct"] as? Bool)!
                let dictRatings : NSDictionary = responseData["ProductReviewOverview"] as! NSDictionary
                self.totalReview = (dictRatings["TotalReviews"] as? Float)!
                self.totalRating = (dictRatings["AverageRating"] as? Float)!
                self.totalViews =  (responseData["NoOfViews"] as? NSInteger)!
                self.ShippingCharge = isNull(responseData["ShippingCharge"] as? String as AnyObject?) ? "" : responseData["ShippingCharge"] as! String
                
                 self.addtionalShipCharge = isNull(responseData["AdditionalShippingCharge"] as? String as AnyObject?) ? "" : responseData["AdditionalShippingCharge"] as! String
                self.dummyShippingCharge = isNull(responseData["DummyShippingCharge"] as? String as AnyObject?) ? "" : responseData["DummyShippingCharge"] as! String
                let dictProduct : NSDictionary = responseData["ProductPrice"] as! NSDictionary
                self.deliveryDays = isNull(responseData["DeliveryDays"] as? String as AnyObject?) ? "" : responseData["DeliveryDays"] as! String
                self.sizeChartUrl = isNull(responseData["SizeChartUrl"] as? String as AnyObject?) ? "" : responseData["SizeChartUrl"] as! String
                self.productDiscount =  isNull(dictProduct["ProductDiscount"] as? String as AnyObject?) ? "" : dictProduct["ProductDiscount"] as! String
                self.customOptions.removeAllObjects();
                self.arrSelectedOptions = NSMutableArray.init();

                if let arrOptions: NSArray = responseData["ProductAttributes"] as? NSArray{
                    if arrOptions.count > 0 {
                        for optDict in arrOptions {
                            let option : CustomOptions = CustomOptions.init(data:optDict as! NSDictionary)
                            self.customOptions.add(option)
                            
                        }
                    }
                }
                
                _completion(true)
                
            }
            else{
                
                _completion(false)
            }
        }
    }
    
    
    open func getPriceWithSelectedOptions(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        var strParam = ""
        let strFilterOptionsName : NSMutableString = ""
        
        if self.arrSelectedOptions.count > 0 {
            strParam = String(format: "[{ \"key\":\"addtocart_%d.EnteredQuantity\", \"value\": \"1\" },", self.id)
            strFilterOptionsName.append(strParam)
            for optionValue in self.arrSelectedOptions{
                strFilterOptionsName.append(String(format:"{ \"key\":\"Product_Attribute_%d_%d_%d\", \"Value\": %d },",(optionValue as! CustomOptions).productId,(optionValue as! CustomOptions).productAttributeId,(optionValue as! CustomOptions).optionId,((optionValue as! CustomOptions).selectedFiled?.valueId)!))
            }
            
            let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
            strFilterOptionsName.deleteCharacters(in: range)
            strFilterOptionsName.append("]")
        }
        
        let strProduct = String(format: "ProductDetailsPagePrice/%d", self.id)
        getDataFromServer(self.arrSelectedOptions.count > 0 ? strFilterOptionsName:strParam as NSString, ENDPOINT.appending(strProduct) as String, POSTMETHOD as String) {
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
    
    
    open func addToWishlist(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        var strParam = ""
        let strFilterOptionsName : NSMutableString = ""
        
        if self.arrSelectedOptions.count > 0 {
            strParam = String(format: "[{ \"key\":\"addtocart_%d.EnteredQuantity\", \"value\": \"1\" },", self.id)
            
            strFilterOptionsName.append(strParam)
            for optionValue in self.arrSelectedOptions{
                strFilterOptionsName.append(String(format:"{ \"key\":\"Product_Attribute_%d_%d_%d\", \"Value\": %d },",(optionValue as! CustomOptions).productId,(optionValue as! CustomOptions).productAttributeId,(optionValue as! CustomOptions).optionId,((optionValue as! CustomOptions).selectedFiled?.valueId)!))
            }
            
            let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
            strFilterOptionsName.deleteCharacters(in: range)
            
            strFilterOptionsName.append("]")
        }
            
        else{
            
            strParam = String(format: "[{ \"key\":\"addtocart_%d.EnteredQuantity\", \"value\": \"1\" }]", self.id)
        }
        
        let strProduct = String(format: "AddProductToCart/%d/2", self.id)
        getDataFromServer(self.arrSelectedOptions.count > 0 ? strFilterOptionsName:strParam as NSString, ENDPOINT.appending(strProduct) as String, POSTMETHOD as String) {
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
    
    open func addToCart(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        var strParam = ""
        let strFilterOptionsName : NSMutableString = ""
        
        if self.arrSelectedOptions.count > 0 {
            strParam = String(format: "[{ \"key\":\"addtocart_%d.EnteredQuantity\", \"value\": \"1\" },", self.id)
            
            strFilterOptionsName.append(strParam)
            for optionValue in self.arrSelectedOptions{
                strFilterOptionsName.append(String(format:"{ \"key\":\"Product_Attribute_%d_%d_%d\", \"Value\": %d },",(optionValue as! CustomOptions).productId,(optionValue as! CustomOptions).productAttributeId,(optionValue as! CustomOptions).optionId,((optionValue as! CustomOptions).selectedFiled?.valueId)!))
            }
            
            let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
            strFilterOptionsName.deleteCharacters(in: range)
            
            strFilterOptionsName.append("]")
        }
            
        else{
            
            strParam = String(format: "[{ \"key\":\"addtocart_%d.EnteredQuantity\", \"value\": \"1\" }]", self.id)
        }
        
        let strProduct = String(format: "AddProductToCart/%d/1", self.id)
        getDataFromServer(self.arrSelectedOptions.count > 0 ? strFilterOptionsName:strParam as NSString, ENDPOINT.appending(strProduct) as String, POSTMETHOD as String) {
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
    
    
    open func deleteFromWishlist(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        
        let strParam = String(format: "[{\"key\":\"Update Wishlist\",\"Value\":\"Update Wishlist\"},{\"key\":\"RemoveFromCart\",\"Value\":%d}]",self.wishListId)
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/UpdateWishlist") as String, POSTMETHOD as String) {
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
    
    open func getRelatedProducts(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "relatedproducts/%d", self.id)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                if let results: NSArray = responseData["Products"] as? NSArray{
                    if results.count > 0 {
                        for proDict in results {
                            let objProduct: Product = Product.init(data: proDict as! NSDictionary)
                            arrResponse.add(objProduct)
                        }
                    }
                }
            }
            
            completion(arrResponse)
        }
    }
    
    open func postReview(_ dict :NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let title = dict["title"] as! String
        let detail = dict["detail"] as! String
        let ratingValue = dict["rating"] as! String
        
        let strProduct = String(format: "product/productreviewsadd/%d", self.id)
        
        let strParam = String(format: "{\"Rating\":%@,\"ReviewText\":\"%@\",\"Title\":\"%@\"}",ratingValue,detail,title)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, POSTMETHOD as String) {
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
    
    open func postVendorReview(_ dict :NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let title = dict["title"] as! String
        let detail = dict["detail"] as! String
        let ratingValue = dict["rating"] as! String
        let vendorID = dict["vendorID"] as! String
        
        let strProduct = String(format: "vendor/reviews/add")
        
        let strParam = String(format: "{\"Rating\":%@,\"ReviewText\":\"%@\",\"Title\":\"%@\",\"VendorId\":%@,\"ProductId\":%d}",ratingValue,detail,title,vendorID,self.id)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, POSTMETHOD as String) {
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
    
    
    open func fetchVendorReview(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        
        let strParam = String(format: "{\"VendorId\":%d,\"ProductId\":%d}",self.vendorID,self.id)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("vendor/reviews") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                let objProduct: ProductReview = ProductReview.init(data: responseData)
                arrResponse.add(objProduct)
            }
            completion(arrResponse)
        }
    }
    
    open func fetchReview(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "product/productreviews/%d",self.id)//, self.id
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                let objProduct: ProductReview = ProductReview.init(data: responseData)
                arrResponse.add(objProduct)
            }
            completion(arrResponse)
        }
    }
    
    
    open func updateCartQty(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        
        let strParam = String(format: "[{\"key\":\"UpdateCart\",\"Value\":\"Update Shopping Cart\"},{\"key\":\"itemquantity%d\",\"Value\":%d}]",self.ShoppingCartid,self.cartQty)
        
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
        let strParam = String(format: "[{\"key\":\"UpdateCart\",\"Value\":\"Update Shopping Cart\"},{\"key\":\"RemoveFromCart\",\"Value\":%d}]",self.ShoppingCartid)
        
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

    open func checkProductAvailablity(strPinCode:String, _ completion: @escaping (_ result: NSDictionary) -> Void){


        let strParam = String(format: "{\"DeliveryPostcode\":%@,\"ProductId\":%d}",strPinCode,self.id)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("Zepo/PincodeService") as String, POSTMETHOD as String) {
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
    
    
    open func isDownloadble()->Bool{
        if self.typeId == downloadable{
            return true
        }
        return false
    }
    
    open func isSimple()->Bool{
        if self.typeId == simple{
            return true
        }
        return false
    }
    
    open func isConfigurable()->Bool{
        if self.typeId == configurable{
            return true
        }
        return false
    }
    
}
