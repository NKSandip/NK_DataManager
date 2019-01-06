//
//  PeopleList.swift
//  HandyNation
//
//  Created by Nirav Shukla on 21/08/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit
import CoreLocation

public func isNull(_ someObject: AnyObject?) -> Bool {
    guard let someObject = someObject else {
        return true
    }
    
    return (someObject is NSNull)
}

class PeopleList: NSObject {
    public var listID : String = ""
    public var navTitle : String = "Canvassing"
    public var isStartCanvasing : Bool = false
    
    public var peopleId = 0
    public var fullName : String?
    
    public var phone : String = ""
    public var isNoPhoneNumber : Bool = false
    
    public var occupation : String?
    public var supportLevel : String?
    
    public var primary_address : String?
    public var city : String?
    public var county : String?
    public var state : String?
    public var zip : String?
    public var cllocation: CLLocation?
    public var userDistance : Double = 0
    public var userTimeDuration : Double = 0
    
    public var profile_image_url_ssl : String?
    
    public var updated_at : String?
    public var created_at : String?
    
    public var isPeopleSelected : Bool = false
    public var objSelectedPeople : PeopleList?
//    var arrCanvasPeople =  NSMutableArray() // get people list from array
    
    open class var sharedManager: PeopleList {
        struct Static {
            static let instance: PeopleList = PeopleList()
        }
        return Static.instance
    }
    
    // MARK: Login User with Email
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        self.peopleId = (addDict["id"] as? NSInteger)!
        
        let firstname = isNull(addDict["first_name"] as? String as AnyObject?) ? "" : addDict["first_name"] as! String
        let lastname = isNull(addDict["last_name"] as? String as AnyObject?) ? "" : addDict["last_name"] as! String
        self.fullName = firstname + " " + lastname
        
        /* == check phone number and mobile number */
        let mobileNumber = isNull(addDict["mobile"] as? String as AnyObject?) ? "" : addDict["mobile"] as! String
        let phoneNumber = isNull(addDict["phone"] as? String as AnyObject?) ? "" : addDict["phone"] as! String
        if phoneNumber.count > 0 {
            self.phone = phoneNumber
        }else if phoneNumber.count == 0 {
            if mobileNumber.count > 0 {
                self.phone = mobileNumber
            }
        }
        if self.phone.count == 0 {
            self.isNoPhoneNumber = true
        }
        /* ========================= */
        
        self.occupation = isNull(addDict["occupation"] as? String as AnyObject?) ? "" : addDict["occupation"] as! String
        self.supportLevel = isNull(addDict["support_level"] as? String as AnyObject?) ? "" : addDict["support_level"] as! String
        
        self.profile_image_url_ssl = isNull(addDict["profile_image_url_ssl"] as? String as AnyObject?) ? "" : addDict["profile_image_url_ssl"] as! String
        self.updated_at = isNull(addDict["updated_at"] as? String as AnyObject?) ? "" : addDict["updated_at"] as! String
        self.created_at = isNull(addDict["created_at"] as? String as AnyObject?) ? "" : addDict["created_at"] as! String
        print(self.fullName as Any)
        
        if addDict["primary_address"] as? NSDictionary != nil {
            let dictAddress = addDict["primary_address"] as? NSDictionary
            self.primary_address = isNull(dictAddress!["address1"] as? String as AnyObject?) ? "" : dictAddress!["address1"] as! String
            self.city = isNull(dictAddress!["city"] as? String as AnyObject?) ? "" : dictAddress!["city"] as! String
            self.state = isNull(dictAddress!["state"] as? String as AnyObject?) ? "" : dictAddress!["state"] as! String
            self.county = isNull(dictAddress!["county"] as? String as AnyObject?) ? "" : dictAddress!["county"] as! String
            
            let strLatitude = isNull(dictAddress!["lat"] as? String as AnyObject?) ? "23.0" : dictAddress!["lat"] as! String
            let strLongitude = isNull(dictAddress!["lng"] as? String as AnyObject?) ? "72.0" : dictAddress!["lng"] as! String
            
            self.cllocation =  CLLocation(latitude: Double(strLatitude)!, longitude: Double(strLongitude)!)
            self.zip = isNull(dictAddress!["zip"] as? String as AnyObject?) ? "" : dictAddress!["zip"] as! String
        }else{
            self.primary_address = ""
            self.cllocation =  CLLocation(latitude: 23.0225, longitude: 72.5714)
            self.zip = ""
            self.city = ""
            self.state = ""
            self.county = ""
        }
        return self
    }
}

// get all mark as done people list
class MarkAsDonePeopleList: NSObject {
    public var ID : String?
    public var person_id = 0
    public var person_name : String?
    public var created_on : String?
    
    public var updated_on : String?
    public var list_id : String?
    public var canvass_slug : String?
    
    public var cllocation: CLLocation?
    
    //    var arrCanvasPeople =  NSMutableArray() // get people list from array
    
    open class var sharedManager: PeopleList {
        struct Static {
            static let instance: PeopleList = PeopleList()
        }
        return Static.instance
    }
    
    // MARK: Login User with Email
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        self.ID = isNull(addDict["ID"] as? String as AnyObject?) ? "0" : addDict["ID"] as! String
        let personID = isNull(addDict["person_id"] as? String as AnyObject?) ? "0" : addDict["person_id"] as! String
        self.person_id = Int(personID)!
        
        self.person_name = isNull(addDict["person_name"] as? String as AnyObject?) ? "" : addDict["person_name"] as! String

        self.updated_on = isNull(addDict["updated_on"] as? String as AnyObject?) ? "" : addDict["updated_on"] as! String
        self.created_on = isNull(addDict["created_on"] as? String as AnyObject?) ? "" : addDict["created_on"] as! String

        let strLatitude = isNull(addDict["lat"] as? String as AnyObject?) ? "23.0" : addDict["lat"] as! String
        let strLongitude = isNull(addDict["lng"] as? String as AnyObject?) ? "72.0" : addDict["lng"] as! String
        self.cllocation =  CLLocation(latitude: Double(strLatitude)!, longitude: Double(strLongitude)!)

        self.list_id = isNull(addDict["list_id"] as? String as AnyObject?) ? "" : addDict["list_id"] as! String
        self.canvass_slug = isNull(addDict["canvass_slug"] as? String as AnyObject?) ? "" : addDict["canvass_slug"] as! String

        return self
    }
}
