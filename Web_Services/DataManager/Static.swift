//
//  Static.swift
//  PSKit
//
//  Created by Aamir  on 6/22/16.
//  Copyright © 2016 Aamir . All rights reserved.
//
import UIKit
import Foundation
let ENDPOINT = "http://fameitc.com/rytzee/api/v1/"  // Live URL
let POSTMETHOD = "POST"
let GETMETHOD = "GET"

let session :URLSession = URLSession.shared
	
public func isNull(_ someObject: AnyObject?) -> Bool {
    guard let someObject = someObject else {
        return true
    }
    
    return (someObject is NSNull)
}

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

public func showAlertView(_dict : NSDictionary) -> Bool{
    if (_dict["status"] as! NSInteger == 1){
        return false
    }
    else{
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: _dict["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                print("OK Button Press")
            }))
            AppDelegate.delegate().topViewController?.present(alert, animated: true, completion: nil)
        }
        return true
    }
}

public func getDataFromServer(_ strParams :NSString,_ strUrl :String, _ strMethod :String ,completionHandler:@escaping (_ success:Bool, _ data: NSDictionary?) -> Void){
    print(strParams)
    let url = URL(string: strUrl)
    var request = URLRequest(url: url!)
    request.httpMethod = strMethod
    if strParams.length > 0{
        let strParam = strParams;
        request.httpBody = strParam.data(using: String.Encoding.utf8.rawValue);
    }
    
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("UTF-8", forHTTPHeaderField: "charset")
    
    //This is just an example, put the Content-request.addValue(User.sharedManager.deviceToken, forHTTPHeaderField: "deviceToken")
    if (DEVICE_TOKEN == nil) {
        print("User Token not exits")
    }else{
        request.addValue(DEVICE_TOKEN!, forHTTPHeaderField: "Token")
    }
    if (UserDefaults.standard.isLoggedIn() == false) {
        print("User Access Token not exits")
    }else{
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authString = "Bearer " + (UserDefaults.standard.getUserAccessToken())
        request.addValue(authString, forHTTPHeaderField: "Authorization")
    }
    print(request);
    session.dataTask(with: request, completionHandler: { data, response, error in
        do {
            print(String.init(data: data!, encoding:.utf8) as Any);
            guard let data = data else {
                throw JSONError.NoData
            }
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                throw JSONError.ConversionFailed
            }
            if !showAlertView(_dict: json){
                completionHandler(true, json)
            }
            else{
                completionHandler(false, nil)
            }
        } catch let error as JSONError {
            print(error.rawValue)
            completionHandler(false, nil)
        } catch let error as NSError {
            print(error.debugDescription)
            completionHandler(false, nil)
        }
    }).resume()
    
}

public func getDataFromServerForPostSurvey(_ strParams :NSString,_ strUrl :String, _ strMethod :String ,completionHandler:@escaping (_ success:Bool, _ data: NSDictionary?) -> Void){
    print(strParams)
    let url = URL(string: strUrl)
    var request = URLRequest(url: url!)
    request.httpMethod = strMethod
    if strParams.length > 0{
        let strParam = strParams;
        request.httpBody = strParam.data(using: String.Encoding.utf8.rawValue);
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("UTF-8", forHTTPHeaderField: "charset")
    
    //This is just an example, put the Content-request.addValue(User.sharedManager.deviceToken, forHTTPHeaderField: "deviceToken")
    if (DEVICE_TOKEN == nil) {
        print("User Token not exits")
    }else{
        request.addValue(DEVICE_TOKEN!, forHTTPHeaderField: "Token")
    }
    if (UserDefaults.standard.isLoggedIn() == false) {
        print("User Access Token not exits")
    }else{
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authString = "Bearer " + (UserDefaults.standard.getUserAccessToken())
        request.addValue(authString, forHTTPHeaderField: "Authorization")
    }
    print(request);
    session.dataTask(with: request, completionHandler: { data, response, error in
        do {
            print(String.init(data: data!, encoding:.utf8) as Any);
            guard let data = data else {
                throw JSONError.NoData
            }
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                throw JSONError.ConversionFailed
            }
            if !showAlertView(_dict: json){
                completionHandler(true, json)
            }
            else{
                completionHandler(false, nil)
            }
        } catch let error as JSONError {
            print(error.rawValue)
            completionHandler(false, nil)
        } catch let error as NSError {
            print(error.debugDescription)
            completionHandler(false, nil)
        }
    }).resume()
    
}
