//
//  User.swift
//  PSKit
//
//  Created by Aamir  on 6/22/16.
//  Copyright © 2016 Aamir . All rights reserved.
//

import Foundation
import UIKit
//Singleton class for user
@objc public enum LOGINTYPE : NSInteger {
    case email = 0
    case facebook = 1
    case google = 2
    case `in` = 4
}

func callScanQRCode() {
        SwiftLoader.show(animated: true)
        DataManager.sharedManager.scanQRCode((passTextField?.text)!) { (dictResponse: NSDictionary) in
            DispatchQueue.main.sync {
                SwiftLoader.hide()
                print(dictResponse)
                guard let messageString = dictResponse["detail"] as? NSDictionary else {
                    return
                }
                let objMember : MemberPass = MemberPass.sharedManager.initWithDictionary(messageString) as! MemberPass
                let objPass : PassViewController = PassViewController(nibName: "PassViewController", bundle: nil)
                objPass.objMemberPass = objMember
                self.navigationController?.pushViewController(objPass, animated: true)
            }
        }
    }
open class Country : NSObject{
    open var countryId : NSInteger = 0
    open var iso2Code : String!
    open var iso3Code : String!
    open var name : String!
    open var regions : NSMutableArray!
    public init(addDict:NSDictionary){
        super.init()
        self.countryId = (addDict["Id"] as? NSInteger)!
        self.iso2Code = isNull(addDict["iso2_code"] as? String as AnyObject?) ? "" : addDict["iso2_code"] as! String
        self.iso3Code = isNull(addDict["iso3_code"] as? String as AnyObject? ) ? "" : addDict["iso3_code"] as! String
        self.name = isNull(addDict["Name"] as? String as AnyObject?) ? "" : addDict["Name"] as! String

        /*self.getStateList { (dictState) in
            DispatchQueue.main.async {
                if let results: NSMutableArray = dictState["region"] as? NSMutableArray{
                    if results.count > 0 {
                        self.regions = results
                    }
                }
            }
        }*/
    }
}


open class UserAddress : NSObject{
    open var addressId : NSInteger = 0
    open var firstName : String!
    open var addressLine1 : String!
    open var addressLine2 : String!
    open var lastName : String!
    open var street : String!
    open var city : String!
    open var region : String!
    open var regionID : String!
    open var telephone : String!
    open var postCode : String!
    open var email : String!
    open var countryId : String!
    open var countryName : String!
    open var stateId : String!
    open var stateName : String!
    open var isDefaultShipping : Bool = false
    open var isDefaultBilling : Bool = false



    open func initWithDictionary(_ addDict:NSDictionary) -> AnyObject{

        self.addressId = (addDict["Id"] as? NSInteger)!
        self.firstName = isNull(addDict["FirstName"] as? String as AnyObject?) ? "" : addDict["FirstName"] as! String
        self.lastName = isNull(addDict["LastName"] as? String as AnyObject?) ? "" : addDict["LastName"] as! String
        self.telephone = isNull(addDict["PhoneNumber"] as? String as AnyObject?) ? "" : addDict["PhoneNumber"] as! String
        self.region = isNull(addDict["StateProvinceName"] as? String as AnyObject?) ? "" : addDict["StateProvinceName"] as! String
        self.city = isNull(addDict["City"] as? String as AnyObject?) ? "" : addDict["City"] as! String
        self.postCode = isNull(addDict["ZipPostalCode"] as? String as AnyObject?) ? "" : addDict["ZipPostalCode"] as! String
        
        self.countryId = isNull(addDict["CountryId"] as? String as AnyObject?) ? "" : addDict["CountryId"] as! String
        self.countryName = isNull(addDict["CountryName"] as? String as AnyObject?) ? "" : addDict["CountryName"] as! String
        
        self.stateId = isNull(addDict["StateProvinceId"] as? String as AnyObject?) ? "" : addDict["StateProvinceId"] as! String
        self.stateName = isNull(addDict["StateProvinceName"] as? String as AnyObject?) ? "" : addDict["StateProvinceName"] as! String
        
        self.addressLine1 = isNull(addDict["Address1"] as? String as AnyObject?) ? "" : addDict["Address1"] as! String
        self.addressLine2 = isNull(addDict["Address2"] as? String as AnyObject?) ? "" : addDict["Address2"] as! String
        self.email = isNull(addDict["Email"] as? String as AnyObject?) ? "" : addDict["Email"] as! String
        self.street = isNull(addDict["street"] as? String as AnyObject?) ? "" : addDict["street"] as! String
        // self.isDefaultBilling = addDict["is_default_billing"] as! Bool
        //self.isDefaultShipping = addDict["is_default_billing"] as! Bool
        return self
    }
}

open class User : NSObject{

    open var customerId = 0
    open var storeId  = 0
    open var fullName : String!
    open var lastName : String!
    open var firstName : String!
    open var middleName : String!
    open var email : String!
    open var mobileNumber : String!
    open var password : String!
    open var loginType : LOGINTYPE = LOGINTYPE.email
    open var groupId  = 0
    open var createdIn : String!
    open var websiteId  = 0
    open var quoteId : String = "0"
    open var deviceToken : String = "0"
    open var deviceID : String = "0"
    open var arrAddress:[UserAddress] = []
    open var selectedAddress : UserAddress?
    open var selectedLang : String?
    open var selectedCurrency : String!
    open var storeID : String!
    open var cartBadgeCount:Int = 0
    open var imageUrl : String!
    open var referralCode : String!
    open var SharingLink : String!
    open var totalLikes : String!
    open var statusLine : String!
    open var countryCode : String!
    open var countryName : String!
    open var cityName : String!
    open var countryId : NSInteger = 0
    open var currantindex : NSInteger = 1
    open var isPushNotification : Bool = true
    open var isDownlineNotification : Bool = true

    open class var sharedManager: User {
        struct Static {
            static let instance: User = User()
        }
        return Static.instance
    }

    open func userId()->AnyObject{
        if(self.customerId==0){
            return UserDefaults.standard.object(forKey: "customerId")! as AnyObject
        }
        else{
            return self.customerId as AnyObject
        }
    }
    
    open func checkInviteFriendFeature(completion: @escaping (_ dictResponse: NSDictionary) -> Void){
        
        let strParam = ""
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("order/anyorders") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
                
            }
        }
    }

    open func sendDeviceID(_ subsID:String, deviceID:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"DeviceTypeId\":5}")

        getDataFromServer(strParam as NSString, ENDPOINT.appending("AppStart") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                if (responseDict!["StatusCode"] as! NSInteger == 200) {
                    self.setLoginStatus(responseDict!)
                }
                completion(responseDict!)

            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }


    open func login(_ phoneNumber:String, pwd:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = String(format: "{\"Value\":\"%@\",\"UserType\":%d}", phoneNumber,0) // With Phone Number
        /*open func login(_ mail:String, pwd:String,completion: @escaping (_ result: NSDictionary) -> Void){
         let strParam = String(format: "{\"Email\":\"%@\",\"Password\":\"%@\",\"UserType\":%d}", mail,pwd,0)*/ // With Email (URL : ("customer/login"))

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/loginusingphonenumber") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success{
                if (responseDict!["StatusCode"] as! NSInteger == 200){
                }
                completion(responseDict!)
            }
            else{
                 let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }

    open func loginWithSocial(_ mail:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"Email\":\"%@\",\"UserType\":%ld}", mail,self.loginType.rawValue)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/login") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                if (responseDict!["StatusCode"] as! NSInteger == 200) {
                }
                completion(responseDict!)

            }
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
//                let dict : NSMutableDictionary = NSMutableDictionary();
//                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
//                completion(dict)
            }
        }
    }


    open func createNewAccount(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){

        let email : String = data["Email"] as! String
        let phoneNumber : String = data["Phone"]as! String
        let firstName : String = data["FirstName"]as! String
        let referrerCode : String = data["ReferralCode"]as! String
        let countryCode : String = data["CountryCode"]as! String
        /*let ipAddress : String = data["IPAddress"]as! String
                let confirmPassword : String = data["ConfirmPassword"]as! String

         let strParam = String(format: "{\"Email\":\"%@\",\"Password\":\"%@\",\"FirstName\":\"%@\",\"ConfirmPassword\":\"%@\",\"ReferralCode\":\"%@\",\"UserType\":%ld,\"IPAddress\":\"%@\",\"CountryCode\":\"%@\"}", email,password,firstName,confirmPassword,referrerCode,self.loginType.rawValue,ipAddress,countryCode)(URL : "customer/register")
         */ // OLD Register Webservices
        let strParam = String(format: "{\"Email\":\"%@\",\"Phone\":\"%@\",\"FirstName\":\"%@\",\"ReferralCode\":\"%@\",\"CountryCode\":\"%@\",\"UserType\":%ld}", email,phoneNumber,firstName,referrerCode,countryCode,0)
        // New Register Webservices
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/register") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success{
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }

        }
    }
    open func verifyOTPforLogin(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let OTPCode : String = data["CustomerOtp"] as! String
        let MobileNumber : String = data["PhoneNumber"]as! String
        let strRegister : String = data["intRegister"]as! String
        var strURLName = ""
        if strRegister.lowercased() == "register" {
            strURLName = "customer/verifyotpforsignup"
        }else{
            strURLName = "customer/verifyotpforlogin"
        }
        
        let strParam = String(format: "{\"CustomerOtp\":\"%@\",\"PhoneNumber\":\"%@\"}", OTPCode,MobileNumber)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strURLName) as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success{
                completion(responseDict!)
            }
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    /*
    open func verifyOTPforLogin(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let OTPCode : String = data["CustomerOtp"] as! String
        let MobileNumber : String = data["PhoneNumber"]as! String
        
        let strParam = String(format: "{\"CustomerOtp\":\"%@\",\"PhoneNumber\":\"%@\"}", OTPCode,MobileNumber)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/verifyotpforlogin") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success{
                completion(responseDict!)
            }
            else{
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                completion(responseData)
            }
        }
        
        // OLD Webservices don't use
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/verifyotpforlogin") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success{
                completion(responseDict!)
            }else{
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                completion(responseData)
            }
        }
    }
 */
    
    open func verifyMobileNumber(_ strMobileNumber:String,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = String(format: "{\"Value\":\"%@\"}", strMobileNumber)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/SendOtp") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }

    open func getMLMUsersWithMobileNumber(_ strMobileNumber:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"Value\":\"%@\"}", strMobileNumber)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/Phonebooksync") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    open func verifyOTPCode(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let OTPCode : String = data["CustomerOtp"] as! String
        let MobileNumber : String = data["PhoneNumber"]as! String
        
        let strParam = String(format: "{\"CustomerOtp\":\"%@\",\"PhoneNumber\":\"%@\"}", OTPCode,MobileNumber)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/VerifyOtp") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    open func createNewSocialAccount(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){

        let email : String = data["Email"] as! String
        let firstName : String = data["FirstName"]as! String
        let registerType : String = data["OAuthAccessToken"]as! String
        let ipAddress : String = data["IPAddress"]as! String
        let countryCode : String = data["CountryCode"]as! String
        
        let strParam = String(format: "{\"Email\":\"%@\",\"FirstName\":\"%@\",\"OAuthAccessToken\":\"%@\",\"UserType\":%ld,\"IPAddress\":\"%@\",\"CountryCode\":\"%@\"}", email,firstName,registerType,self.loginType.rawValue,ipAddress,countryCode)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/register") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func updateProfile(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = String(format: "{\"Email\":\"%@\",\"Phone\":\"%@\",\"FirstName\":\"%@\",\"StatusLine\":\"%@\",\"CountryId\":\"%d\",\"City\":\"%@\"}",self.email,self.mobileNumber,self.firstName,self.statusLine,self.countryId,self.cityName)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/info") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                let responseData :NSDictionary = responseDict!["Data"]! as! NSDictionary;
                completion(responseData)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func deleteAvatar(completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "")

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/DeleteCostomerAvtar") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }


    open func getMyDetails(completion: @escaping (_ dictResponse: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/info") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)

            }
        }
    }

   open func uploadImage(image : UIImage,_ completion: @escaping (_ result: NSDictionary) -> Void)
    {
        let url = NSURL(string: ENDPOINT.appending("customer/uploadavtar"))
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()
        //define the multipart request type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(User.sharedManager.deviceID, forHTTPHeaderField: "DeviceId")
        request.addValue(User.sharedManager.deviceToken, forHTTPHeaderField: "Token")
        request.addValue("UTF-8", forHTTPHeaderField: "charset")

        let image_data = UIImagePNGRepresentation(image)

        if(image_data == nil)
        {
            completion(NSDictionary.dictionaryWithValues(forKeys: ["Error"]) as NSDictionary)
            return
        }

        let body = NSMutableData()

        let fname = "test.png"
        let mimetype = "image/png"

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"uploadfile\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        request.httpBody = body as Data

        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in

            guard let _:Data = data, let _:URLResponse = response , error
                == nil else {
                    return
            }

//            let dataString = String(data: data!, encoding:
//                String.Encoding(rawValue: String.Encoding.utf8.rawValue))

            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                if !showAlertView(_dict: json){

                    completion(json)
                }
                else{
                    completion(json)
                }
            } catch let error as JSONError {
                completion(NSDictionary.dictionaryWithValues(forKeys: ["Error"]) as NSDictionary)
            } catch let error as NSError {
                completion(NSDictionary.dictionaryWithValues(forKeys: ["Error"]) as NSDictionary)
            }
        }

        task.resume()

    }


    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }


    open func redeemReferralCode(_ strCode:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"Value\":\"%@\"}",strCode)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/useReferralCode") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func doCustomerLikeDislike(_ customerId:NSInteger,like:Bool,completion: @escaping (_ result: NSDictionary) -> Void){

         let strParam = String(format: "{\"CustomerId\":%d,\"CustomerLikeId\":%d,\"Like\":%@}",self.customerId,customerId,NSNumber.init(booleanLiteral: like))

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/like") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func changePassword(_ strPassword:String,completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = String(format: "{\"OldPassword\":\"%@\",\"NewPassword\":\"%@\",\"ConfirmNewPassword\":\"%@\"}",self.password,strPassword,strPassword)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/changepass") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func forgotPassword(_ strEmail:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"Email\":\"%@\"}}", strEmail)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/passwordrecovery") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }

    open func deleteAddress(_ userAddress:UserAddress,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

         let strProduct = String(format: "customer/address/remove/%d", userAddress.addressId)

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success{
                completion(responseDict!)
            }
            else{

                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }

    open func getCountryList(_ completion:@escaping (_ result:NSMutableArray) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("countries") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                let responseData :NSDictionary = responseDict!;
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    if let results: NSArray = responseData["Data"] as? NSArray{
                        if results.count > 0 {
                            for dict in results {
                                let objCountry : Country = Country.init(addDict:dict as! NSDictionary)
                                arrResponse.add(objCountry)
                            }
                        }
                    }
                }
            }

            completion(arrResponse)
        }
    }

    open func getStateList(_ strCountryId : NSInteger, completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "country/getstatesbycountryid/%d", strCountryId)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }
    
    open func getCurrencyList(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("setting/currencies") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }

    open func setCurranencyToApp(_ strcode : NSInteger,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "")

         let strUrl = String(format: "set/currency/%d",strcode)

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrl) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }
    
    open func setCountryToApp(_ strcode : NSInteger,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = String(format: "")
        
        let strUrl = String(format: "set/country/%d",strcode)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrl) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }
                
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }

    open func getCurrantCurrency(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("get/currency") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }

    open func getLanguageList(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"resource\":\"customer\",\"method\":\"getLanguage\",\"params\":{}}")

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
                completion(dict)

            }
        }
    }


    open func getAddresses(_ completion:@escaping (_ result:[UserAddress]) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/addresses") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            self.arrAddress.removeAll()
            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    if let results: NSArray = responseDict?["Data"] as? NSArray{
                        if results.count > 0 {
                            for dict in results {
                                let objAddress : UserAddress = UserAddress().initWithDictionary(dict as! NSDictionary) as! UserAddress
                                self.arrAddress.append(objAddress)
                            }
                        }
                    }
                }
            }

            completion(self.arrAddress)
        }
    }

    open func addNewAddress(_ objAddress:UserAddress,completion:@escaping (_ result:NSDictionary) -> Void){

        let strParam = String(format: "[{\"key\":\"Address.Address1\",\"value\":\"%@\"},{\"key\":\"Address.Address2\",\"value\":\"%@\"},{\"key\":\"Address.ZipPostalCode\",\"value\":\"%@\"},{\"key\":\"Address.City\",\"value\":\"%@\"},{\"key\":\"Address.StateProvinceId\",\"value\":\"%@\"},{\"key\":\"Address.CountryId\",\"value\":\"%@\"},{\"key\":\"Address.Email\",\"value\":\"%@\"},{\"key\":\"Address.FirstName\",\"value\":\"%@\"},{\"key\":\"Address.LastName\",\"value\":\"%@\"},{\"key\":\"Address.PhoneNumber\",\"value\":\"%@\"}]",objAddress.addressLine1,objAddress.addressLine2,objAddress.postCode,objAddress.city,objAddress.regionID,objAddress.countryId,objAddress.email,objAddress.firstName,objAddress.lastName,objAddress.telephone)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/address/add") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }

    open func setAddressToCart(_ objAddress:UserAddress,completion:@escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"value\":%d}", objAddress.addressId)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/checkoutsaveadressid/2") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }


    open func getMainCategories(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("categoriesnew/0") as String, GETMETHOD as String) {// "categories" this is older name
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success{
                let responseData :NSArray = responseDict!["Data"]! as! NSArray;
                if responseData.count > 0 {
                    for catDict in responseData {
                        let objCategory: Categories = Categories.init(dict: catDict as! NSDictionary)
                        objCategory.checCategoryPinterest()
                        arrResponse.add(objCategory)
                    }
                }
            }
             completion(arrResponse)
        }

    }

    open func getSidePanelCategories(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("categories/0/1") as String, GETMETHOD as String) {
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

    open func recentlyViewedProducts(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam =  ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("Product/RecentlyViewedProducts/20") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }

                completion(arrResponse)
            }
            
        }
    }

    open func newArrivalProducts(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam =  ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("HomepageNewArrival/20") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }

                completion(arrResponse)
            }
            
        }
    }


    open func dashboardProducts(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam =  String(format: "{\"pageNumber\":%d,\"PageSize\":%d}", 0,10)
        getDataFromServer(strParam as NSString, ENDPOINT.appending("homepageproducts") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }

                completion(arrResponse)
            }
            
        }
    }

    open func getBanners(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("homepagebanner") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                     let  responseData :NSArray = responseDict!["Data"] as! NSArray;
                        if responseData.count > 0 {
                            for banDict in responseData {
                                let objBanner: Banner = Banner.init(dict: banDict as! NSDictionary)
                                arrResponse.add(objBanner)
                            }
                        }
                     completion(arrResponse)
            }
        }
    }

    open func searchProduct(_ strkeyword :String,page:NSInteger,completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = String(format: "{\"q\":\"%@\",\"pageNumber\":%d}}", strkeyword,page)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("catalog/search") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                            let TotalPages : NSNumber = NSNumber.init(value: responseData["TotalPages"] as! NSInteger)
                            arrResponse.add(TotalPages)
                        }
                    }
                }

                completion(arrResponse)
            }

        }
    }

    open func searchTags(_ strkeyword :String,completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = String(format: "{\"Value\":\"%@\"}}", strkeyword)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("get/tags") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()

            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSArray = responseDict!["Data"] as! NSArray;
                        if responseData.count > 0 {
                            for proDict in responseData {

                                arrResponse.add(proDict)
                            }
                        }
                }

                completion(arrResponse)
            }
            
        }
    }


    //Will contain array of product objects


    open  func getMyWishlist(_ completion: @escaping (_ result: NSMutableDictionary) -> Void){

        let strParam = ""
        var  responseData = NSMutableDictionary()
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/wishlist_old") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {

                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    responseData = responseDict!["Data"] as! NSMutableDictionary;
                }
            }

            completion(responseData)
        }
        
    }


    open func getMyFavorites(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/wishlist") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {

                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }
            }

            completion(arrResponse)
        }

    }

    open func getLevelList(_ completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = "{\"resource\":\"vaf\",\"method\":\"options\"}"
        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success{
                let responseData :NSDictionary = responseDict!;
                let keyExists = responseDict!["data"] != nil
                if keyExists {
                    if let results: NSArray = responseData["data"] as? NSArray{
                        if results.count > 0 {
                            arrResponse.addObjects(from: results as! [String])
                        }
                    }
                }
            }
            completion(arrResponse)
        }

    }

    open func getSubLevelList(_ strLevelName:String,strSelectedLevelName:String,completion: @escaping (_ result: NSMutableArray) -> Void){

        var strParam = ""

        if strLevelName == ""{
             strParam = "{\"resource\":\"vaf\",\"method\":\"getfilter\",\"params\":{\"filter\":{}}}"
        }
        else{

            strParam =   String(format: "{\"resource\":\"vaf\",\"method\":\"getfilter\",\"params\":{\"requestlevel\":\"%@\",\"filter\":{%@}}}",strLevelName,strSelectedLevelName)
        }

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success{
                let responseData :NSDictionary = responseDict!;
                let keyExists = responseDict!["data"] != nil
                if keyExists {
                    if let results: NSArray = responseData["data"] as? NSArray{
                        if results.count > 0 {
                            arrResponse.addObjects(from: results as! [NSDictionary])
                        }
                    }
                }
            }
            completion(arrResponse)
        }
        
    }


    open  func getFilteredProductList(_ strSelectedLevelName:String,completion: @escaping (_ result: NSMutableArray) -> Void){

        let strParam = String(format: "{\"resource\":\"catalog\",\"method\":\"vaf\",\"params\":{\"vaffilter\":{%@}}}", strSelectedLevelName)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {

                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }
                }
            }

            completion(arrResponse)
        }
        
    }

    open func SavePreferenceProductList(_ strPrefrenceName:String,completion: @escaping (_ result: NSMutableDictionary) -> Void){
        
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
        let strParam = String(format: "{\"Value\":\"%@\"}",strPrefrenceName)
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/SavePreference") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let dictResponse : NSMutableDictionary = NSMutableDictionary()
            dictResponse.setValue(responseDict, forKey: "Data")
            completion(dictResponse)
        }
    }
    
    open func findSavePreferenceProductList(_ strParam : NSString,completion: @escaping (_ result: NSMutableArray) -> Void){
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ProductFilter") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
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
            completion(arrResponse)
        }
    }
    
    open func clearPrefrenceList(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let strUrl = ""
        getDataFromServer(strUrl as NSString, ENDPOINT.appending("customer/ClearSavePreference") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                let responseData :NSDictionary = responseDict!;
                completion(responseData)
                return;
            }
            completion(responseDict!)
        }
    }
    
    
    open func getPreferenceList(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        let strUrl = ""
        getDataFromServer(strUrl as NSString, ENDPOINT.appending("customer/GetSavePreference") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                let keyExists = responseDict!["Data"] as? NSArray != nil
                if keyExists {
                    let responseData :NSArray = responseDict!["Data"]! as! NSArray;
                    arrResponse.add(responseData)
                }
            }
            completion(arrResponse)
        }
    }
    
    open  func getVendorProductList(_ vendorId:NSInteger,page:NSInteger,completion: @escaping (_ result: NSMutableDictionary) -> Void){
        let strParam = String(format: "{\"type\":4,\"sellerId\":%d,\"pageNumber\":%d,\"PageSize\":10}", vendorId,page)
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
                            for proDict in results {
                                let objPro: Product = Product.init(data: proDict as! NSDictionary)
                                arrResponse.add(objPro)
                            }
                        }
                    }

                }
            }
                dictResponse.setValue(arrResponse, forKey: "arrProduct")
                completion(dictResponse)
            }
    }

    open func addProdcutToCart(_ objProduct:Product,completion: @escaping (_ result: NSDictionary) -> Void){

        let proID = String(objProduct.id)
        let custID : String = String(self.customerId)

        let strParam : String



        if objProduct.customOptions.count > 0 && objProduct.arrSelectedConfigurable.count==0 {
            let strOptions : NSMutableString = ""
            for objOptions in objProduct.customOptions {

                strOptions.append(String(format:"\"%@\":\"%@\",",(objOptions as! CustomOptions).optionId,((objOptions as! CustomOptions).selectedFiled?.valueId)!))
            }
            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)

            strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"addCart\",\"params\":{\"customer_id\":\"%@\",\"product_id\":\"%@\",\"qty\":\"1\", \"options\":{%@}}}", custID,proID,strOptions)
        }
        else if objProduct.customOptions.count == 0 && objProduct.arrSelectedConfigurable.count > 0 {
            let strOptions : NSMutableString = ""
            for dict  in objProduct.arrSelectedConfigurable {
                let optionID = dict["optionId"] as! String
                let valueID = dict["valueId"] as! String

                strOptions.append(String(format:"\"%@\":\"%@\",",optionID,valueID))
            }

            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)
            strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"addCart\",\"params\":{\"customer_id\":\"%@\",\"product_id\":\"%@\",\"qty\":\"1\", \"super_attribute\":{%@}}}", custID,proID,strOptions)

        }
        else if objProduct.customOptions.count > 0 && objProduct.arrSelectedConfigurable.count > 0 {
            let strOptions : NSMutableString = ""
            let strConfigurable : NSMutableString = ""
            for dict  in objProduct.arrSelectedConfigurable {
                let optionID = dict["optionId"] as! String
                let valueID = dict["valueId"] as! String

                strConfigurable.append(String(format:"\"%@\":\"%@\",",optionID,valueID))
            }

            let range :NSRange = NSMakeRange(strConfigurable.length-1, 1)
            strConfigurable.deleteCharacters(in: range)


            /*for objOptions in objProduct.customOptions {

                // strOptions.append(String(format:"\"%@\":\"%@\",",(objOptions as AnyObject).option_id,((objOptions as! CustomOptions).selectedFiled?.value_id)!))
            }*/

            let rangeOptions :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: rangeOptions)

            strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"addCart\",\"params\":{\"customer_id\":\"%@\",\"product_id\":\"%@\",\"qty\":\"1\", \"options\":{%@}, \"super_attribute\":{%@}}}", custID,proID,strOptions,strConfigurable)
        }
        else{

            strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"addCart\",\"params\":{\"customer_id\":\"%@\",\"product_id\":\"%@\",\"qty\":\"%@\"}}", custID,proID,"1")
        }

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                let keyExists = responseDict!["data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["data"] as! NSDictionary;
                    let cart: NSDictionary = responseData["cart"] as! NSDictionary
                    self.quoteId = String(cart["quote_id"] as! String)
                    self.resetQuoteData()
                    let dictUser :NSDictionary = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
                    self.setUserData(dictUser)
                    objProduct.arrSelectedConfigurable.removeAll();
                    objProduct.arrSelectedCustomOptions.removeAll();

                    for objOptions in objProduct.customOptions {

                        (objOptions as! CustomOptions).selectedFiled=nil;
                    }

                }

                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
                completion(dict)
                
            }
        }
        

    }

    open func addDownloadbleProdcutToCart(_ objProduct:Product,completion: @escaping (_ result: NSDictionary) -> Void){
        let proID = String(objProduct.id)
        let custID : String = String(self.customerId)
        var strParam : String = ""

        let strDownload : NSMutableString = ""
        for objDownload in objProduct.arrSelectedDownloadable {

            strDownload.append(String(format:"\"%@\":\"%@\",",String(describing: objProduct.arrSelectedDownloadable.index(of: objDownload)),objDownload.linkId))
        }

        let range :NSRange = NSMakeRange(strDownload.length-1, 1)
        strDownload.deleteCharacters(in: range)

        strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"addCart\",\"params\":{\"customer_id\":\"%@\",\"product_id\":\"%@\",\"qty\":\"1\", \"options\":{000}, \"links\":{%@}}}", custID,proID,strDownload)

        if objProduct.customOptions.count > 0 {
            let strOptions : NSMutableString = ""
            /*for objOptions in objProduct.customOptions {

                //strOptions.append(String(format:"\"%@\":\"%@\",",(objOptions as AnyObject).option_id,((objOptions as! CustomOptions).selectedFiled?.value_id)!))
            }*/
            let range :NSRange = NSMakeRange(strOptions.length-1, 1)
            strOptions.deleteCharacters(in: range)

            strParam = strParam.replacingOccurrences(of: "000", with: strOptions as String)
        }
        else{
            strParam = strParam.replacingOccurrences(of: "000", with:"")
        }


        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                let keyExists = responseDict!["data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["data"] as! NSDictionary;
                    let cart: NSDictionary = responseData["cart"] as! NSDictionary
                    self.quoteId = String(cart["quote_id"] as! String)
                    self.resetQuoteData()
                    let dictUser :NSDictionary = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
                    self.setUserData(dictUser)
                    objProduct.arrSelectedDownloadable.removeAll();
                }

                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
                completion(dict)
                
            }
        }
        
    }

    open func updateItemQty(_ objCartPorduct:CartProduct,completion: @escaping (_ result: NSDictionary) -> Void){

        let qty = String(objCartPorduct.qty)
        let strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"updatecartQty\",\"params\":{\"quote_id\":\"%@\",\"item_id\":\"%@\",\"qty\":\"%@\"}}", self.quoteId,objCartPorduct.itemID,qty)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
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


    open func deleteProductFromCart(_ itemID:String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"deleteItem\",\"params\":{\"quote_id\":\"%@\",\"item_id\":\"%@\"}}", self.quoteId,itemID)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
        
    }

    //Return the array of cart containing products object.
    open  func getMyCart(_ cartProductId:String,completion: @escaping (_ result: NSMutableDictionary) -> Void){
        let strParam = cartProductId
        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            let  dictResponse :NSMutableDictionary = NSMutableDictionary()
            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["Products"] as? NSArray{
                        if results.count > 0 {
                            for proDict in results {
                                let objCartPro: Product = Product.init(data:proDict as! NSDictionary)
                                arrResponse.add(objCartPro)
                            }
                        }
                    }

                    dictResponse.setValue(arrResponse, forKey: "CartProducts")
                    dictResponse.setValue(responseData.value(forKey: "CustomerCreditsSummary"), forKey: "CreditsSummary")
                    dictResponse.setValue(responseData.value(forKey: "OrderTotalResponseModel"), forKey: "CartTotalDetails")

                    dictResponse.setValue(responseData.value(forKey: "CurrentShippingAddress"), forKey: "CartShippingAddress")
                }
            }

            completion(dictResponse)
        }
    }

    open func getCartTotal(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCart/TotalItem") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }

    open func getCartTotalForSelectedItems(_ strcode : String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("ShoppingCartTotal") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }



    open func getOrderList(_ completion: @escaping (_ result: NSMutableArray) -> Void){
        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("order/customerorders") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            let arrResponse : NSMutableArray = NSMutableArray()
            if success {
                 let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                if let results: NSArray = responseData["Orders"] as? NSArray{
                    if results.count > 0 {
                        for dict in results {
                            let objOrder: Order = Order.init(data:dict as! NSDictionary)
                            arrResponse.add(objOrder)
                        }
                    }
                }
            }

            completion(arrResponse)
        }

    }


    open func applyCode(_ strcode : String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"setPromoCode\",\"params\":{\"quote_id\":\"%@\",\"coupon_code\":\"%@\"}}", self.quoteId,strcode)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }

    open func getPaymentMethod(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/checkoutgetpaymentmethod") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }
    // Payal changes 7/03/2018
    open func getPaymentMethodNew(_ strcode : String,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = strcode//String(format: "{\"Value\":\"%@\"} ",strcode)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/checkoutgetpaymentmethodnew") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }
                
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }

    open func setPaymentMethodToCart(_ strcode : String,completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"Value\":\"%@\"} ",strcode)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/checkoutsavepaymentmethod") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }

    open func getShippingMethod(_ completion: @escaping (_ result: NSDictionary) -> Void){

        let strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"getShipping\",\"params\":{\"quote_id\":\"%@\"}}", self.quoteId)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
                completion(dict)
                
            }
        }
    }
    
    open func setShippingMethodToCart(_ strcode : String,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = String(format: "{\"resource\":\"checkout\",\"method\":\"setShipping\",\"params\":{\"quote_id\":\"%@\",\"code\":\"%@\"}}", self.quoteId,strcode)
        
        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }
                
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                dict.setValue("There is some issue to process your request. Please try later.", forKey:"errormessage");
                completion(dict)
                
            }
        }
    }
    
    open func placeOrderWith2Checkout(_ strOrderId:String,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "order/twocheckout/%@", strOrderId)
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }
            else{
                
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }
    

    open func placeOrder(_creditValue : NSInteger,arrProduct : NSMutableArray,completion: @escaping (_ result: NSDictionary) -> Void){
        
//        SelectedCartIds
        let strCart : NSMutableString = NSMutableString()
        for objProduct in arrProduct {
            let obj : Product = objProduct as! Product
            strCart.append("\""+String(obj.ShoppingCartid)+"\""+",")
        }
        let range :NSRange = NSMakeRange(strCart.length-1, 1)
        strCart.deleteCharacters(in: range)
        
//        {"SelectedRewardPointsType":"2","SelectedCartIds" : ["3222"]}
        
        let strParam = String(format: "{\"SelectedRewardPointsType\":\"%d\",\"SelectedCartIds\":[%@]}", _creditValue,strCart)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/checkoutcomplete") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }
                
            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }


//
    open func updateOrderStatus(tranctionID : String,orderId : String,arrProduct : NSMutableArray,completion: @escaping (_ result: NSDictionary) -> Void){

        let strCart : NSMutableString = NSMutableString()
        for objProduct in arrProduct {
            let obj : Product = objProduct as! Product
            strCart.append("\""+String(obj.ShoppingCartid)+"\""+",")
        }
        let range :NSRange = NSMakeRange(strCart.length-1, 1)
        strCart.deleteCharacters(in: range)

        let strParam = String(format: "{\"TransactionId\":\"%@\",\"OrderId\":\"%@\",\"SelectedCartIds\":[%@]}", tranctionID,orderId,strCart)

        getDataFromServer(strParam as NSString, ENDPOINT.appending("checkout/edit/order") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)

            }
        }
    }

    open func cancelOrder(orderId : String,completion: @escaping (_ result: NSDictionary) -> Void){


        let strParam = ""

        let strUrlParams = String(format: "order/cancelorder/%@", orderId)

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }

            else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
                
            }
        }
    }

    open func getProductDetails(_ productID:String,completion: @escaping (_ objProduct: Product) -> Void){

        let strParam = String(format: " {\"resource\":\"catalog\",\"method\":\"detailInfo\",\"params\":{\"product_id\":\"%@\"}}", productID)

        getDataFromServer(strParam as NSString, ENDPOINT as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                 let  responseData :NSDictionary = responseDict!["data"] as! NSDictionary;
               let result: NSDictionary = responseData["product"] as! NSDictionary
                let obj: Product = Product.init(data: result)
                completion(obj)

            }
        }
    }

    open func getMyWalletDetails(completion: @escaping (_ dictResponse: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/credits/summary") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                completion(responseDict!)
            }
        }
    }

    open func getMyWalletHistoryByType(_ walletType:NSInteger,completion: @escaping (_ dictResponse: NSDictionary) -> Void){

         let strParam = ""
        let strUrlParams = String(format: "customer/credits/log/%d", walletType)

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                
                completion(responseDict!)

            }
        }
    }

    open func setReimbursementData(_ data:NSDictionary,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let creditPoint : String = data["CreditPoint"] as! String
        let creditCardNo : String = data["CreditCardNo"]as! String
        let creditComment : String = data["CreditComment"]as! String
        let creditCardType : String = data["CreditCardType"]as! String
        
        let strParam = String(format: "{\"CreditPoint\":\"%@\",\"CreditCardNo\":\"%@\",\"CreditCardType\":\"%@\",\"CreditComment\":\"%@\"}", creditPoint,creditCardNo,creditCardType,creditComment)
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/encash/add") as String, POSTMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }
            else{
                
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }
    
    open func getFavouriteMLMTree(completion: @escaping (_ dictResponse: NSMutableArray) -> Void){

        let strParam = ""
        let strUrlParams = String(format: "customer/favoritelist")

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                let arrLeval0 : NSMutableArray = NSMutableArray()
                if let results: NSArray = responseDict?["Data"] as? NSArray{
                    if results.count > 0 {

                        
                        for dict in results {
                            let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                            arrLeval0.add(objOrder)
                        }
                    }

                }

                completion(arrLeval0)
            }
            else{
                completion(NSMutableArray())
            }
        }
    }

    open func getMLMLevelCount(completion: @escaping (_ dictResponse: NSMutableDictionary) -> Void){
        let strParam = ""
        let strUrlParams = String(format: "customer/mlmlevelcount")
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                let dictMLMLevel :NSMutableDictionary = NSMutableDictionary();
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    dictMLMLevel.setValue(responseData["MlMLevel0Count"], forKey: "Level1")
                    dictMLMLevel.setValue(responseData["MlMLevel1Count"], forKey: "Level2")
                    dictMLMLevel.setValue(responseData["MlMLevel2Count"], forKey: "Level3")
                    dictMLMLevel.setValue(responseData["MlMLevel3Count"], forKey: "Level4")
                    dictMLMLevel.setValue(responseData["MlMLevel4Count"], forKey: "Level5")
                    dictMLMLevel.setValue(responseData["MlMLevel5Count"], forKey: "Level6")
                    dictMLMLevel.setValue(responseData["Id"], forKey: "MLMId")
                }
                completion(dictMLMLevel)
            }
            else{
                completion(NSMutableDictionary())
            }
        }
    }
    
    open func getMLMTree(_ mlmLevel:NSInteger,page:NSInteger,completion: @escaping (_ dictResponse: NSMutableDictionary) -> Void){
        var strParam = ""
        if mlmLevel == 7{
            strParam = String(format: "{\"pageNumber\":%d,\"PageSize\":%d}", page, 20)
        }else{
            strParam = String(format: "{\"pageNumber\":%d,\"PageSize\":%d,\"MlmLevel\":%d}", page, 20,mlmLevel)
        }
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/customertreenew") as String, POSTMETHOD as String) {(success:Bool, responseDict: NSDictionary?) in
            
            let dictMLMTree :NSMutableDictionary = NSMutableDictionary();
            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    if let results: NSArray = responseData["MlMLevel0"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval0 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval0.add(objOrder)
                            }
                            
                            let dictLeval0 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval0.setValue(arrLeval0, forKey: "MlMLevel")
                            dictLeval0.setValue("Level 1", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval0, forKey:"Level1")
                        }
                    }
                    
                    if let results: NSArray = responseData["MlMLevel1"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval1 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval1.add(objOrder)
                            }
                            
                            let dictLeval1 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval1.setValue(arrLeval1, forKey: "MlMLevel")
                            dictLeval1.setValue("Level 2", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval1, forKey:"Level2")
                        }
                    }
                    
                    
                    if let results: NSArray = responseData["MlMLevel2"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval2 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval2.add(objOrder)
                            }
                            
                            let dictLeval2 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval2.setValue(arrLeval2, forKey: "MlMLevel")
                            dictLeval2.setValue("Level 3", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval2, forKey:"Level3")
                        }
                    }
                    
                    if let results: NSArray = responseData["MlMLevel3"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval3 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval3.add(objOrder)
                            }
                            
                            let dictLeval3 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval3.setValue(arrLeval3, forKey: "MlMLevel")
                            dictLeval3.setValue("Level 4", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval3, forKey:"Level4")
                        }
                    }
                    
                    if let results: NSArray = responseData["MlMLevel4"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval4 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval4.add(objOrder)
                            }
                            
                            let dictLeval4 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval4.setValue(arrLeval4, forKey: "MlMLevel")
                            dictLeval4.setValue("Level 5", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval4, forKey:"Level5")
                        }
                    }
                    
                    if let results: NSArray = responseData["MlMLevel5"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval5 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval5.add(objOrder)
                            }
                            
                            let dictLeval5 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval5.setValue(arrLeval5, forKey: "MlMLevel")
                            dictLeval5.setValue("Level 6", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval5, forKey:"Level6")
                        }
                    }
                    
                    
                    if let results: NSArray = responseData["MlMLevel6"] as? NSArray{
                        if results.count > 0 {
                            let arrLeval6 : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrLeval6.add(objOrder)
                            }
                            
                            let dictLeval6 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval6.setValue(arrLeval6, forKey: "MlMLevel")
                            dictLeval6.setValue("Level 7", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval6, forKey:"Level7")
                        }
                    }
                    
                    
                    if let results: NSArray = responseData["MyDownline"] as? NSArray{
                        if results.count > 0 {
                            let arrMyLeval : NSMutableArray = NSMutableArray()
                            
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrMyLeval.add(objOrder)
                            }
                            
                            let dictLeval7 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval7.setValue(arrMyLeval, forKey: "MlMLevel")
                            dictLeval7.setValue("Level 7", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval7, forKey:"MyDownline")
                        }
                    }
                    dictMLMTree.setValue(responseData["TotalRecords"], forKey: "TotalRecords")
                    dictMLMTree.setValue(responseData["TotalPages"], forKey: "TotalPages")
                    dictMLMTree.setValue(responseData["PageNumber"], forKey: "PageNumber")
                }else{
                    if self.currantindex > 1 {
                        self.currantindex = self.currantindex - 1
                    }
                }
            }
            completion(dictMLMTree)
        }
    }
    
    open func getMLMGlobalAndRelatedMLMList(_ isGlobal:Bool,customerID:String,completion: @escaping (_ dictResponse: NSMutableDictionary) -> Void){
        var strUrlParams = ""
        var CustId = customerID
        if isGlobal == true{
            strUrlParams = String(format: "customer/customertreegetall")
            CustId = String(self.customerId)
        }else{
            strUrlParams = String(format: "customer/customertreebycustomeridnew")
        }
        let strParam = String(format: "{\"pageNumber\":%d,\"PageSize\":%d,\"CustomerId\":%@}", self.currantindex, 20,CustId)
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, POSTMETHOD as String) {(success:Bool, responseDict: NSDictionary?) in

            let dictMLMTree :NSMutableDictionary = NSMutableDictionary();
            if success {
                let keyExists = responseDict!["Data"] != nil
                if keyExists {
                    let  responseData :NSDictionary = responseDict!["Data"] as! NSDictionary;
                    
                    if let results: NSArray = responseData["MyDownline"] as? NSArray{
                        if results.count > 0 {
                            let arrMyLeval : NSMutableArray = NSMutableArray()
                            self.currantindex = self.currantindex + 1
                            for dict in results {
                                let objOrder: MLMUser = MLMUser.init(data:dict as! NSDictionary)
                                arrMyLeval.add(objOrder)
                            }
                            
                            let dictLeval7 :NSMutableDictionary = NSMutableDictionary();
                            dictLeval7.setValue(arrMyLeval, forKey: "MlMLevel")
                            dictLeval7.setValue("Level 7", forKey:"Title")
                            
                            dictMLMTree.setValue(dictLeval7, forKey:"MyDownline")
                            dictMLMTree.setValue(responseData["TotalRecords"], forKey: "TotalRecords")
                            dictMLMTree.setValue(responseData["TotalPages"], forKey: "TotalPages")
                            dictMLMTree.setValue(responseData["PageNumber"], forKey: "PageNumber")
                        }
                    }
                }else{
                    if self.currantindex > 1 {
                        self.currantindex = self.currantindex - 1
                    }
                }
            }
            completion(dictMLMTree)
        }
    }

    open func getMLMUserProfileDetails(_ userId:NSInteger,completion: @escaping (_ dictResponse: NSDictionary) -> Void){

        let strParam = ""
        let strUrlParams = String(format: "customer/mlmprofile/%d", userId)

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                
                completion(responseDict!)

            }
        }
    }

    open func getNotificationList(completion: @escaping (_ dictResponse: NSDictionary) -> Void){

        let strParam = ""

        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/notification/log") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                
                completion(responseDict!)

            }
        }
    }

    open func clearNotificationList(_ notificationId:NSInteger,completion: @escaping (_ dictResponse: NSDictionary) -> Void){

        let strParam = ""
        let strUrlParams = String(format: "customer/notification/ClearLogByNotificationType/%d", notificationId)
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in

            if success {
                
                completion(responseDict!)
            }
        }
    }
    
    open func doPurchaseNotificationOnOff(OnOff:Bool,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        let strUrlParams = String(format: "customer/PurchaseNotification/%@",NSNumber.init(booleanLiteral: OnOff))

        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }
            else{
                
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }
    
    open func doDownlineNotificationOnOff(OnOff:Bool,completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        let strUrlParams = String(format: "customer/DownlineNotification/%@",NSNumber.init(booleanLiteral: OnOff))
        
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strUrlParams) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success{
                completion(responseDict!)
            }
            else{
                
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
            
        }
    }
    
    open func setAddCustomerQuery(queryTitle : NSInteger,queryMessage : String,completion: @escaping (_ result: NSDictionary) -> Void){
            
            let strParam = String(format: "{\"QueryType\":%d,\"Message\":\"%@\"}", queryTitle,queryMessage)
            
            getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/AddCustomerQuery") as String, POSTMETHOD as String) {(success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
                
            }
        }
    }
    
    //order/returnreasons
    open func getResonforRequestList(_ completion: @escaping (_ result: NSDictionary) -> Void){
        
        let strParam = ""
        
        let strProduct = String(format: "order/returnreasons")
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
    
    open func checkUserRequestReimbursementEncash(completion: @escaping (_ dictResponse: NSDictionary) -> Void){
    
        let strParam = ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/encash/check") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                completion(responseDict!)
                
            }
        }
    }
    
    
    open func isLoggedIn()->Bool{
        let state :Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if state == false {
            return state
        }
        else{
            if self.isNotNull(UserDefaults.standard.value(forKey: "userData") as AnyObject?) {
                 let dictUser :NSDictionary = UserDefaults.standard.value(forKey: "userData") as! NSDictionary
                setUserData(dictUser)
                return state
            }
            return false;
        }
    }

    func isNotNull(_ object:AnyObject?) -> Bool {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object) && isNotStringNull(object))
    }

    func isNotNSNull(_ object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }

    func isNotStringNull(_ object:AnyObject) -> Bool {
        if let object = object as? String , object.uppercased() == "NULL" {
            return false
        }
        return true
    }

    open func setLoginStatus(_ dictParams:NSDictionary)->Void{

        UserDefaults.standard.set(true, forKey: "isLogin")
        UserDefaults.standard.set(dictParams, forKey: "userData")
        UserDefaults.standard.synchronize();
    }

    open func setUserData(_ dictParams:NSDictionary){
        let  responseData :NSDictionary = dictParams["data"] as! NSDictionary;
        let dict = responseData["customer"] as! NSDictionary
        User.sharedManager.customerId = dict["customer_id"] as! Int
        User.sharedManager.firstName = dict["firstname"] as! String
        User.sharedManager.middleName = dict["middlename"] as! String
        User.sharedManager.lastName = dict["lastname"] as! String
        User.sharedManager.fullName = dict["firstname"] as! String
        User.sharedManager.email = dict["email"] as! String

        let quote = responseData["quote"] as! NSDictionary


        if (quote as? NSDictionary) != nil
        {
            User.sharedManager.quoteId = quote["quote_id"] as! String
        }
    }

    open func resetQuoteData(){

        let dictUser :NSDictionary = UserDefaults.standard.value(forKey: "userData") as! NSDictionary

        let dictNew :NSMutableDictionary = NSMutableDictionary();
        dictNew.addEntries(from: dictUser as NSDictionary as [NSObject : AnyObject])

        let dictData: NSMutableDictionary = NSMutableDictionary()
        dictData.addEntries(from: dictNew["data"] as! NSMutableDictionary as [NSObject : AnyObject])

        let dictCustomer: NSMutableDictionary = NSMutableDictionary()
        let oldCustomer: NSMutableDictionary = dictNew["data"] as! NSMutableDictionary
        dictCustomer.addEntries(from: oldCustomer["customer"] as! NSMutableDictionary as [NSObject : AnyObject])
        dictCustomer.setValue(self.firstName, forKey: "firstname")
        dictCustomer.setValue(self.middleName, forKey: "middlename")
        dictCustomer.setValue(self.lastName, forKey: "lastname")

        dictData.setObject(dictCustomer, forKey: "customer" as NSCopying)

        let cart: NSMutableDictionary = NSMutableDictionary()
        cart.setValue(self.quoteId, forKey: "quote_id")
        dictData.setObject(cart, forKey: "quote" as NSCopying)
        dictNew.setObject(dictData, forKey: "data" as NSCopying)

        UserDefaults.standard.set(dictNew, forKey: "userData")
        UserDefaults.standard.synchronize();
    }
    
    open func getmyIpAddress(completion: @escaping (_ dictResponse: NSDictionary) -> Void){
        let strParam = ""
        getDataFromServer(strParam as NSString, ENDPOINT.appending("customer/GetClientIP") as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            
            if success {
                completion(responseDict!)
            }
            
        }
    }
    
    open func logout(_ completion: @escaping (_ result: NSDictionary) -> Void){
        let strParam = ""
        let strProduct = String(format: "customer/logout")
        getDataFromServer(strParam as NSString, ENDPOINT.appending(strProduct) as String, GETMETHOD as String) {
            (success:Bool, responseDict: NSDictionary?) in
            if success {
                completion(responseDict!)
            }else{
                let dict : NSMutableDictionary = NSMutableDictionary();
                completion(dict)
            }
        }
    }
}

