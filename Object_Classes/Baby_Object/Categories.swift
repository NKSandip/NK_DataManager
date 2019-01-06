//
//  File.swift
//  PSKit
//
//  Created by Aamir  on 6/22/16.
//  Copyright © 2016 Aamir . All rights reserved.
//

import Foundation


@objc public enum SortType : Int{

    case position   = 0
    case nameAsc    = 5
    case nameDesc   = 6
    case priceAsc   = 10
    case priceDesc  = 11
    case popular    = 20
    case createdOn  = 15
    case popularASc = 25
}

open class Categories : NSObject{
    
    open var id : NSInteger = 0
    open var parent_id : NSInteger = 0
    open var name : String
    open var desc : String
    open var imageUrl : String
    open var position : NSInteger = 0
    open var level : NSInteger = 0
    open var childCount : NSInteger = 0
    open var productCount : NSInteger = 0
    open var TotalPagesCount : NSInteger = 0
    open var currantindex : NSInteger = 1
    open var typeID : NSInteger = 0
    open var isCategory = Bool()
    open var isPinterstCategory = Bool()
    open var isSubCategory = Bool()
    open var arrProducts = NSMutableArray()
    open var dictItems = NSMutableDictionary()
    open var arrFilters : [CategoryFilter] = []

    public init(dict:NSDictionary){
        
        self.id = dict["Id"] as! NSInteger;
        self.parent_id = dict["ParentCategoryId"] as! NSInteger;
        self.name = isNull(dict["Name"] as? String as AnyObject?) ? "" : dict["Name"] as! String
        self.desc = isNull(dict["description"] as? String as AnyObject?) ? "" : dict["description"] as! String
        self.imageUrl = isNull(dict["IconPath"] as? String as AnyObject?) ? "" : dict["IconPath"] as! String
        // self.position = dict["position"] as! NSInteger;
        self.level = dict["DisplayOrder"] as! NSInteger;

        if let count = dict["Subcategory"] as? Int {
            self.childCount = count;
        }
       
        self.isCategory = dict["IsCategory"] as! Bool;
        self.isSubCategory = dict["Subcategory"] as! Bool;
        self.typeID = dict["Type"] as! NSInteger;
        
        /*if let isCate : Bool = dict["IsCategory"] as? Bool{
            if isCate == true{
                if let intTypeID : NSInteger = dict["Id"] as? NSInteger{
                    if (intTypeID == 83 || intTypeID == 2 || intTypeID == 3){
                        self.isPinterstCategory = true
                    }else{
                        self.isPinterstCategory = false
                    }
                }
            }else{
                if let intTypeID : NSInteger = dict["Type"] as? NSInteger{
                    if intTypeID == 1{
                        self.isPinterstCategory = true
                    }else{
                        self.isPinterstCategory = false
                    }
                }
            }
        }*/
    }
    
    public func checCategoryPinterest() {
        if self.isCategory == true {
            if (self.id == 83 || self.id == 84 || self.id == 355){
                self.isPinterstCategory = true
            }else{
                self.isPinterstCategory = false
            }
        }else{
            if (self.typeID == 1 || self.typeID == 2 || self.typeID == 3 || self.typeID == 13 || self.typeID == 14){
                self.isPinterstCategory = true
            }else{
                self.isPinterstCategory = false
            }
        }
    }
    
    open func getSubCategories(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strUrl = String(format: "categories/%d/1",self.id)

        getDataFromServer("" as NSString, ENDPOINT.appending(strUrl) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success{
                let responseData :NSArray = responseDict!["Data"]! as! NSArray;
                if responseData.count > 0 {
                    for catDict in responseData {
                        let objCategory: Categories = Categories.init(dict: catDict as! NSDictionary)
                        arrResponse.add(objCategory)
                    }
                }
            }
            completion(arrResponse)
        }
        
    }

    open func getAllProdcutsByCategory(_ completion: @escaping (_ result: NSMutableDictionary) -> Void){


        let strParam = String(format: "{\"type\":%d,\"CategoryId\":%d,\"PageNumber\":%d,\"PageSize\":10}", self.typeID,self.id,self.currantindex)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ProductFilter") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let arrResponse : NSMutableArray = NSMutableArray()
            let dictResponse : NSMutableDictionary = NSMutableDictionary()
            
            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;

                    if let priceData = responseData["PriceRange"] as? NSDictionary {
                        dictResponse.setValue(priceData, forKey: "priceData")
                    }
                    else{

                        dictResponse.setValue(NSDictionary(), forKey: "priceData")
                    }
                    dictResponse.setValue(responseData["TotalPages"], forKey: "TotalPages")
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            self.currantindex = self.currantindex + 1
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }
                else{
                    if self.currantindex > 1 {

                        self.currantindex = self.currantindex - 1
                    }
                }
                dictResponse.setValue(arrResponse, forKey: "arrProduct")
            }
            completion(dictResponse)
        }
    }
    
    
    open func getProducts(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        let catID = String(self.id)
        let index = String(self.currantindex)
        
        let strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"pageindex\":\"%@\"}}", catID, index)
        
        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                self.currantindex = self.currantindex + 1
                let responseData :NSDictionary = responseDict!["data"]! as! NSDictionary;
                if let results: NSArray = responseData["products"] as? NSArray{
                    if results.count > 0 {
                        for proDict in results {
                            let objCategory: Product = Product.init(data: proDict as! NSDictionary)
                            arrResponse.add(objCategory)
                        }
                    }
                }
            }
            else{
                
                if self.currantindex > 1 {
                    
                    self.currantindex = self.currantindex - 1
                }
            }
            completion(arrResponse)
        }
        
    }
    
    open func getFilterList(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strUrl = String(format: "ProductAttributes/%d",self.id)
        getDataFromServer("" as NSString, ENDPOINT.appending(strUrl) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success{
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                let filterArray :NSArray = responseData["ProductAttributes"]! as! NSArray;
                if filterArray.count > 0 {
                    for catDict in filterArray {
                        let objCategory: CategoryFilter = CategoryFilter.init(dict: catDict as! NSDictionary,cateID:self.id)
                        arrResponse.add(objCategory)
                    }
                }
            }
            completion(arrResponse)
        }
    }

    
    open func sortProductList(_ sortType : SortType,strPage :NSInteger,completion: @escaping (_ result: NSMutableDictionary) -> Void){
        
        let strParam = String(format: "{\"CategoryId\":%d,\"OrderBy\":%d,\"PageNumber\":%d,\"PageSize\":10}",self.id,sortType.rawValue,strPage)
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ProductFilter") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let arrResponse : NSMutableArray = NSMutableArray()
            let dictResponse : NSMutableDictionary = NSMutableDictionary()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;

                    if let priceData = responseData["PriceRange"] as? NSDictionary {
                        dictResponse.setValue(priceData, forKey: "priceData")
                    }
                    else{

                        dictResponse.setValue(NSDictionary(), forKey: "priceData")
                    }

                    dictResponse.setValue(responseData["TotalPages"], forKey: "TotalPages")

                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            self.currantindex = self.currantindex + 1
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }

                }
                else{
                    if self.currantindex > 1 {

                        self.currantindex = self.currantindex - 1
                    }
                }
                dictResponse.setValue(arrResponse, forKey: "arrProduct")
                completion(dictResponse)
            }
        }
        
    }

    open func getFilteredProductList(_ sortType : SortType,minPrice :NSInteger,maxPrice :NSInteger,completion: @escaping (_ result: NSMutableDictionary) -> Void){

         let strOptions : NSMutableString = ""

        if self.arrFilters.count > 0 {
            for filters  in self.arrFilters{
                if filters.arrSelectedFilters.count > 0 {

                    let strFilterOptionsName : NSMutableString = ""
                    for optionValue  in filters.arrSelectedFilters{
                         strFilterOptionsName.append(String(format:"\"%@\",",filters.isName == true ? (optionValue as! FilterOptions).lable : String((optionValue as! FilterOptions).value)))
                    }

                    let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
                    strFilterOptionsName.deleteCharacters(in: range)

                    // let strFilterOptions : NSMutableString = ""

                    let strFilterOptions : String = (String(format:"{\"MainAttribute\":\"%@\",\"Sub_Attributes\":[%@]},",filters.label,strFilterOptionsName))
                    strOptions.append(strFilterOptions)
                }


            }
            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)
        }

        let strParam = String(format: "{\"CategoryId\":%d,\"PageNumber\":%d,\"PageSize\":10,\"OrderBy\":%d,\"PriceRange\":{\"From\":%d,\"To\":%d},\"FilteredSpecs\":[%@]}",self.id,self.currantindex,sortType.rawValue,minPrice,maxPrice,strOptions)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("ProductFilter") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            let dictResponse : NSMutableDictionary = NSMutableDictionary()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    
                    if let priceData = responseData["PriceRange"] as? NSDictionary {
                        dictResponse.setValue(priceData, forKey: "priceData")
                    }
                    else{
                        
                        dictResponse.setValue(NSDictionary(), forKey: "priceData")
                    }
                    dictResponse.setValue(responseData["TotalPages"], forKey: "TotalPages")
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            self.currantindex = self.currantindex + 1
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }
                else{
                    if self.currantindex > 1 {
                        
                        self.currantindex = self.currantindex - 1
                    }
                }
                dictResponse.setValue(arrResponse, forKey: "arrProduct")
            }
            completion(dictResponse)
            
            /*if success {
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                if let results: NSArray = responseData["Products"] as? NSArray{
                    if results.count > 0 {
                        for proDict in results {
                            let objCategory: Product = Product.init(data: proDict as! NSDictionary)
                            arrResponse.add(objCategory)
                        }
                    }
                }
            }
            else{

            }
            completion(arrResponse)*/
        }

    }
    
    open func SavePreferenceProductList(strPrefrenceName:NSString,completion: @escaping (_ result: NSMutableDictionary) -> Void){
        
//        let strParam : String(format: "{\"CategoryId\":%d,}")
        /*
        if self.arrFilters.count > 0 {
            for filters  in self.arrFilters{
                if filters.arrSelectedFilters.count > 0 {
                    let strFilterOptionsName : NSMutableString = ""
                    for optionValue  in filters.arrSelectedFilters{
                        strFilterOptionsName.append(String(format:"\"%@\",",filters.isName == true ? (optionValue as! FilterOptions).lable : String((optionValue as! FilterOptions).value)))
                    }
                    let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
                    strFilterOptionsName.deleteCharacters(in: range)
                    let strFilterOptions : String = (String(format:"{\"MainAttribute\":\"%@\",\"Sub_Attributes\":[%@]},",filters.label,strFilterOptionsName))
                    strOptions.append(strFilterOptions)
                }
            }
            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)
        }
        
        let strParam = String(format: "{\"CategoryId\":%d,\"PageNumber\":%d,\"PageSize\":10,\"OrderBy\":%d,\"PriceRange\":{\"From\":%d,\"To\":%d},\"FilteredSpecs\":[%@]}",self.id,strPage,sortType.rawValue,minPrice,maxPrice,strOptions)
        
        let strModel : NSMutableString = "{\"Data\":"
        strModel.append(strParam)
        strModel.append(",\"FilterPreferenceName\":")
        let strFilterOptions : String = (String(format:"{\"Value\":\"%@\"}",strPrefrenceName))
        strModel.append(strFilterOptions)
        strModel.append("}")
       */
        
        let strParam = String(format: "{\"Value\":%@}",strPrefrenceName)
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/SavePreference") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let dictResponse : NSMutableDictionary = NSMutableDictionary()
            dictResponse.setValue(responseDict, forKey: "Data")
            completion(dictResponse)
        }
    }
    
    open func getSortProductParamWithEnum(_ sortType : SortType, pageIndex: String) -> (String){
        let catID = String(self.id)
        let index = pageIndex
        var strParam : String = ""
        let strOptions : NSMutableString = ""
        if self.arrFilters.count > 0 {
            for filters  in self.arrFilters{
                strOptions.append(String(format:"\"%@\":\"%@\",",filters.code,(filters.selectedFilter?.value)!))
            }
            
            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)
        }
        
        switch (sortType) {
        case .nameAsc:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"new\",\"sortdir\":\"asc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)
        case .nameDesc:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"new\",\"sortdir\":\"desc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)
        case .popular:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"name\",\"sortdir\":\"asc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)
        case .popularASc:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"name\",\"sortdir\":\"desc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)
        case .priceAsc:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"price\",\"sortdir\":\"asc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)
        case .priceDesc:
            strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"categoryProducts\",\"params\":{\"catId\":\"%@\",\"filter\":{%@},\"sort\":\"price\",\"sortdir\":\"desc\",\"pageindex\":\"%@\"}}", catID,strOptions, index)

        default : break


        }
        
         return strParam
    }
    
}
