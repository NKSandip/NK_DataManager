//
//  User.swift
//  OnDemandApp
//  Created by Sourabh Bhardwaj on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

class UserRegister : NSObject {
    public var userfirstname : String?
    public var userlastname : String?
    public var useremail : String?
    public var userpassword : String?
    
}

class User: NSObject {
    
    //TODO: remove id variable
    public var customerId = 0
    public var completedSurvey = 0
    public var expiresIn = 0
    public var name : String!
    public var email : String!
    public var created_at : String!
    public var updated_at : String!
    public var accessToken : String = "0"
    public var password : String!
    public var deviceToken : String = "0"
    public var deviceID : String = "0"
    public var hasSelectedDestination = 0
    
    required override init() {
        super.init()
    }
    
    // MARK: - NSCoding protocol methods
    required init?(coder aDecoder: NSCoder){
        super.init()
        
        //Int(aDecoder.decodeObject(forKey: "isEmailVerified") as! String)! as NSNumber
        self.customerId = aDecoder.decodeObject(forKey: "id") as! NSInteger
        self.completedSurvey = aDecoder.decodeObject(forKey: "completed_survey") as! NSInteger
        self.expiresIn = aDecoder.decodeObject(forKey: "expires_in") as! NSInteger

        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String

        self.created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        self.updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String

        self.accessToken = (aDecoder.decodeObject(forKey: "access_token") as? String)!
        
        self.password = aDecoder.decodeObject(forKey: "access_token") as? String
        self.deviceToken = aDecoder.decodeObject(forKey: "access_token") as! String
        
        self.deviceID = aDecoder.decodeObject(forKey: "access_token") as! String
        self.hasSelectedDestination = aDecoder.decodeObject(forKey: "has_selected_destination") as! NSInteger
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.customerId, forKey: "id")
        aCoder.encode(self.completedSurvey, forKey: "completed_survey")
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        
        aCoder.encode(self.accessToken, forKey: "access_token")
        aCoder.encode(self.expiresIn, forKey: "expires_in")
        
        aCoder.encode(self.password, forKey: "access_token")
        aCoder.encode(self.deviceToken, forKey: "access_token")
        
        aCoder.encode(self.deviceID, forKey: "access_token")
        aCoder.encode(self.hasSelectedDestination, forKey: "has_selected_destination")
    }
}

