//
//  User+Services.swift
//  OnDemandApp
//  Created by Sourabh Bhardwaj on 07/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

func getCurrentUser() -> User? {
    let defaults = UserDefaults.standard
    let encodedObject = defaults.object(forKey: "user") as? Data
    var object: User? = nil
    if let anObject = encodedObject {
        object = NSKeyedUnarchiver.unarchiveObject(with: anObject) as? User
    }
    return object
}
// MARK: - ### API Handling ###
extension UserRegister {
    
    open class var sharedManager: UserRegister {
        struct Static {
            static let instance: UserRegister = UserRegister()
        }
        return Static.instance
    }
}

// MARK: - ### API Handling ###
extension User {
    
    open class var sharedManager: User {
        struct Static {
            static let instance: User = User()
        }
        return Static.instance
    }
    
    // MARK: Login User with Email
    func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{
        let responseData : NSDictionary = addDict["data"]! as! NSDictionary;
        if responseData.count > 0 {
            let userData : NSDictionary = responseData["user"]! as! NSDictionary;
            if userData.count > 0 {
                self.customerId = (userData["id"] as? NSInteger)!
                self.completedSurvey = (userData["completed_survey"] as? NSInteger)!
                self.name = isNull(userData["name"] as? String as AnyObject?) ? "" : userData["name"] as! String
                self.email = isNull(userData["email"] as? String as AnyObject?) ? "" : userData["email"] as! String
                self.created_at = isNull(userData["created_at"] as? String as AnyObject?) ? "" : userData["created_at"] as! String
                self.updated_at = isNull(userData["updated_at"] as? String as AnyObject?) ? "" : userData["updated_at"] as! String
                self.hasSelectedDestination = (userData["has_selected_destination"] as? NSInteger)!
            }
            self.accessToken = isNull(responseData["access_token"] as? String as AnyObject?) ? "" : responseData["access_token"] as! String
            self.expiresIn = (responseData["expires_in"] as? NSInteger)!
            self.password = isNull(responseData["access_token"] as? String as AnyObject?) ? "" : responseData["access_token"] as! String
            self.deviceToken = isNull(responseData["access_token"] as? String as AnyObject?) ? "" : responseData["access_token"] as! String
            self.deviceID = isNull(responseData["access_token"] as? String as AnyObject?) ? "" : responseData["access_token"] as! String
        }
        return self
    }
    
    // MARK: - Save CurrentUserData
    /*func saveCustomObject() {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: User.self)
        let defaults = UserDefaults.standard
        defaults.set(encodedObject, forKey: "user")
        defaults.synchronize()
    }*/
}
