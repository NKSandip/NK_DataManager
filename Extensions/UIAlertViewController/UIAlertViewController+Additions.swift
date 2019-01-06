//
//  UIAlertController+Addiotios.swift
//  OnDemandApp
//  Created by Pawan Joshi on 31/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit
// MARK: - UIAlertController Extension
extension UIAlertController {
    
    /**
     Present alert with ok  buttton only.
     
     - parameter title:     String which show as title
     - parameter message :  String which show as message
     - parameter handler:   Callback action to handle action

     - returns:  Completion handler returns callback to function
     */
    func alertWithOk(_ title:String, message:String, handler:((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.default, handler:handler))
        return alert
    }
    
    /**
     Present alert with ok and cancel butttons.
     
     - parameter title:     String which show as title
     - parameter message :  String which show as message
     - parameter handler:   Callback action to handle action

     - returns : Completion handler returns callback to function
     */
    func alertWithOkAndCancel(_ title:String, message:String, handler:((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.default, handler:handler))
        alert.addAction(UIAlertAction(title: NSLocalizedString("CANCEL", comment: "CANCEL"), style: UIAlertActionStyle.cancel, handler:handler))
        return alert
    }
    
    /**
     Present alert with multiple buttons which we want to pass in button title.
     
     - parameter title:     String which show as title
     - parameter message :  String which show as message
     - parameter handler:   Callback action to handle action

     - returns: Completion handler returns callback to function
     */
    func confirmAlertWithMultipleButtons(_ title:String, message:String, arrayButtons:NSArray, handler:((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        for buttonTitle in arrayButtons {
            
            alert.addAction(UIAlertAction(title: buttonTitle as? String, style: UIAlertActionStyle.default, handler:handler))
        }
        return alert
    }
}
