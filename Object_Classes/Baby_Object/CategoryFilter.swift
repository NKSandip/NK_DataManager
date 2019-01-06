//
//  CategoryFilter.swift
//  MComm
//
//  Created by imac13 on 7/25/16.
//  Copyright © 2016 PerceptionSystem. All rights reserved.
//

import UIKit

open class FilterOptions: NSObject  {

    open  var value :NSInteger = 0
    open  var parentID :NSInteger = 0
    open  var lable :String!
    open  var colorSquaresRgb :String!
    open  var hasSubAttributes :Bool = false
    open var arrSubAttributes :NSMutableArray = NSMutableArray()
    public init(dict:NSDictionary){
        self.value = (dict["Id"] as? NSInteger)!
        self.parentID = (dict["ParentCategoryId"] as? NSInteger)!
        self.lable = isNull(dict["Name"] as? String as AnyObject?) ? "" : dict["Name"] as! String
        self.colorSquaresRgb = isNull(dict["ColorSquaresRgb"] as? String as AnyObject?) ? "" : dict["ColorSquaresRgb"] as! String
    }

}

open class CategoryFilter: NSObject {

    open  var filterID :NSInteger = 0
    open var code :String!
    open var label :String!
    open var isName :Bool!
    open var type :String!
    open var arrOptions :NSMutableArray = NSMutableArray()
    open var selectedFilter : FilterOptions?
    open var arrSelectedFilters :NSMutableArray = NSMutableArray()
    public init(dict:NSDictionary, cateID:NSInteger){
        self.filterID = (dict["ProductAttributeId"] as? NSInteger)!
        self.code = isNull(dict["code"] as? String as AnyObject?) ? "" : dict["code"] as! String
        self.label = isNull(dict["Name"] as? String as AnyObject?) ? "" : dict["Name"] as! String
        self.type = isNull(dict["type"] as? String as AnyObject?) ? "" : dict["type"] as! String
        self.isName = (dict["IsName"] as? Bool)!


        if let arrAddtional: NSArray = dict["Values"] as? NSArray{
            if arrAddtional.count > 0 {

                if self.label == "Category"{
                    let speciesPredicate = NSPredicate(format: "ParentCategoryId == %d", cateID)
                    let filteredArray = (arrAddtional as NSArray).filtered(using: speciesPredicate)
                    for optDict in filteredArray {
                        let options = FilterOptions.init(dict:optDict as! NSDictionary)
                        let speciesPredicate = NSPredicate(format: "ParentCategoryId == %d", options.value)
                        let subArray = (arrAddtional as NSArray).filtered(using: speciesPredicate)
                        if subArray.count > 0 {
                            options.hasSubAttributes = true;
                            options.arrSubAttributes = NSMutableArray.init()
                            for subDict in subArray {
                                let subOptions = FilterOptions.init(dict:subDict as! NSDictionary)
                                options.arrSubAttributes.add(subOptions)
                                let innerPredicate = NSPredicate(format: "ParentCategoryId == %d", subOptions.value)
                                let innerArray = (arrAddtional as NSArray).filtered(using: innerPredicate)
                                if innerArray.count > 0 {
                                    subOptions.arrSubAttributes = NSMutableArray.init()
                                    subOptions.hasSubAttributes = true;
                                    for innerDict in innerArray {
                                        let innerOptions = FilterOptions.init(dict:innerDict as! NSDictionary)
                                        subOptions.arrSubAttributes.add(innerOptions)
                                    }
                                }
                            }

                        }

                        self.arrOptions.add(options)
                    }

                }else{
                    for optDict in arrAddtional {
                        let options = FilterOptions.init(dict:optDict as! NSDictionary)
                        self.arrOptions.add(options)
                    }
                }
            }
        }
    }
}
