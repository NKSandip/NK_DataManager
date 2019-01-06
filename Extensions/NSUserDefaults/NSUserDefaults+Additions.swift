//
//  NSUserDefaults+Additions.swift
//  OnDemandApp
//  Created by Anish Kumar on 20/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
enum UserDefaultsKeys : String {
    case isLoggedIn
    case userName
    case userID
    case userAccessToken
    case isSurvey
    case isHasSelectedSurvey
}
// MARK: - NSUserDefaults Extension
extension UserDefaults {
    
    // MARK: - User Defaults
    /**
     sets/adds object to NSUserDefaults
     
     - parameter aObject: object to be stored
     - parameter defaultName: key for object
     */
    class func setObject(_ value: AnyObject?, forKey defaultName: String) {
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    
    /**
     gives stored object in NSUserDefaults for a key
     
     - parameter defaultName: key for object
     
     - returns: stored object for key
     */
    class func objectForKey(_ defaultName: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: defaultName) as AnyObject?
    }
    
    /**
     removes object from NSUserDefault stored for a given key
     
     - parameter defaultName: key for object
     */
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.standard.removeObject(forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    //MARK: Save User Access Token
    func setUserName(value: String){
        set(value, forKey: UserDefaultsKeys.userName.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserName() -> String{
        return string(forKey: UserDefaultsKeys.userName.rawValue)!
    }
    
    //MARK: Save User Data
    func setUserID(value: Int){
        set(value, forKey: UserDefaultsKeys.userID.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserID() -> Int{
        return integer(forKey: UserDefaultsKeys.userID.rawValue)
    }
    //MARK: Save User Data
    func setHasSelectedSurveyID(value: Int){
        set(value, forKey: UserDefaultsKeys.isHasSelectedSurvey.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getHasSelectedSurveyID() -> Int{
        return integer(forKey: UserDefaultsKeys.isHasSelectedSurvey.rawValue)
    }
    
    //MARK: Save User Access Token
    func setUserAccessToken(value: String){
        set(value, forKey: UserDefaultsKeys.userAccessToken.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserAccessToken() -> String{
        return string(forKey: UserDefaultsKeys.userAccessToken.rawValue)!
    }
    
    //MARK: Check Survey
    func setSurvey(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isSurvey.rawValue)
        //synchronize()
    }
    
    func isSurvey()-> Bool {
        return bool(forKey: UserDefaultsKeys.isSurvey.rawValue)
    }
}
