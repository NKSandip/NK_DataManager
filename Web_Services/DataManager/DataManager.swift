//
//  DataManager.swift
//  Rytzee
//
//  Created by Nirav Shukla on 27/07/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    open class var sharedManager: DataManager {
        struct Static {
            static let instance: DataManager = DataManager()
        }
        return Static.instance
    }
    // MARK: Create New User with Email
    open func createNewUserWithEmail(_ firstName:String, lastName:String,email:String, pwd:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let fullname = firstName + " " + lastName
        var strParam = ""
        if DEVICE_TOKEN == nil {
            strParam = String(format: "name=%@&email=%@&password=%@&device_token=%@&device_type=%d", fullname,email,pwd,UUID().uuidString,2) // With Email Address
        }else{
            strParam = String(format: "name=%@&email=%@&password=%@&device_token=%@&device_type=%d", fullname,email,pwd,DEVICE_TOKEN!,2)
        }
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("register") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Login User with Email
    open func loginWithEmail(_ email:String, pwd:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = String(format: "email=%@&password=%@", email,pwd) // With Email Address
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("login") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Register User with Social
    open func registerWithSocial(_ name:String, email:String, socialType:String, providerid:String,completion: @escaping (_ result: NSDictionary) -> Void){
        var strParam = ""
        if DEVICE_TOKEN == nil {
            strParam = String(format: "name=%@&email=%@&provider=%@&provider_id=%@&device_type=%@&device_token=%@", name,email,socialType,providerid,"2",UUID().uuidString) // With Social
        }else{
            strParam = String(format: "name=%@&email=%@&provider=%@&provider_id=%@&device_type=%@&device_token=%@", name,email,socialType,providerid,"2",DEVICE_TOKEN!) // With Social
        }
        getDataFromServer(strParam as NSString, ENDPOINT.appending("register/social") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Register User with Social
    open func loginWithSocial(_ name:String, email:String, socialType:String, providerid:String,completion: @escaping (_ result: NSDictionary) -> Void){
        var strParam = ""
        if DEVICE_TOKEN == nil {
            strParam = String(format: "name=%@&email=%@&provider=%@&provider_id=%@&device_type=%@&device_token=%@", name,email,socialType,providerid,"2",UUID().uuidString) // With Social
        }else{
            strParam = String(format: "name=%@&email=%@&provider=%@&provider_id=%@&device_type=%@&device_token=%@", name,email,socialType,providerid,"2",DEVICE_TOKEN!) // With Social
        }
        getDataFromServer(strParam as NSString, ENDPOINT.appending("login/social") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Logout with Email
    open func logOut(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = "" // With Email Address
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("logout") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Get all Survery Question List with option and Type
    open func getSurvayList(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = "" // With Email Address
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("questions") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: selected Survery Post from server
    open func postSurvey(_ arrSurvey:NSMutableArray, strSurveyOptions:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = ""
        getDataFromServerForPostSurvey(arrSurvey.count > 0 ? strSurveyOptions as NSString:strParam as NSString, ENDPOINT.appending("survey") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Get All Location List with Searhc and WithoutSeach Option
    open func getAllLocationListWithSearchOptionORWithoutSearchOption(_ isSearch: Bool, searchText: String ,completion: @escaping (_ result: NSDictionary) -> Void){
        let str = ""
        var strParam = ""
        if isSearch == true {
            strParam = String(format: "%@?page=%d&search=%@",ENDPOINT.appending("location"), LocationPlace.sharedManager.paggination,searchText) // Search List
        }else {
            strParam = String(format: "%@?page=%d",ENDPOINT.appending("locations"), LocationPlace.sharedManager.paggination) // Survey List
        }

        getDataFromServer(str as NSString, strParam as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Get All Experiences List
    open func getAllExperiencesListOption(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let str = ""
        let strParam = String(format: "%@?page=%d",ENDPOINT.appending("experiences"), ExperienceList.sharedManager.paggination) // Experience List
        getDataFromServer(str as NSString, strParam, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Get All Favourites List
    open func getAllFavouritesListOption(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let str = ""
        let strParam = String(format: "%@?page=%d",ENDPOINT.appending("user/favourites"), ExperienceList.sharedManager.paggination) // Experience List
        getDataFromServer(str as NSString, strParam, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: Get All OFFERS List
    open func getAllOffersListOption(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let str = ""
        let strParam = String(format: "%@?page=%d",ENDPOINT.appending("offers"), OffersList.sharedManager.paggination) // Experience List
        getDataFromServer(str as NSString, strParam, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    // MARK: experinceOffer LikeDislike WithType Email
    open func experinceOfferLikeDislikeWithType(_ model_id:Int, type:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let str = ""
        let strParam = String(format: "%@?model_id=%d&type=%@",ENDPOINT.appending("experience/favourite"), model_id,type) // Experience List
        getDataFromServer(str as NSString, strParam, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["status"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    open func getWeather(_  placeName: String, completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = "" //
        let strURL = "https://weather.cit.api.here.com/weather/1.0/report.json?product=forecast_7days_simple&name="+placeName+"&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg"

        getDataFromServer(strParam as NSString, strURL, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success == true{
                if (responseDict!["metric"] as! NSInteger == 1){
                    completion(responseDict!)
                }
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
}
