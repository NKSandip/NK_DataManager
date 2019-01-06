//
//  Constant.swift
//  HandyNation
//
//  Created by coreway solution on 30/11/17.
//  Copyright © 2017 Corway Solution. All rights reserved.
//

import Foundation
import UIKit
struct Constants
{
    static let isiPhone4 = ((UIScreen.main.bounds.size.height==480.0) || (UIScreen.main.bounds.size.width==480.0))
    static let isiPhone5 = ((UIScreen.main.bounds.size.height==568.0) || (UIScreen.main.bounds.size.width==568.0))
    static let isiPhone6 = ((UIScreen.main.bounds.size.height==375.0) || (UIScreen.main.bounds.size.width==375.0))
    static let isiPhone6p = ((UIScreen.main.bounds.size.height==414.0) || (UIScreen.main.bounds.size.width==414.0))
    static let isiPad = ((UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) && ((UIScreen.main.bounds.size.height==1024.0) || (UIScreen.main.bounds.size.width==1024.0)))
    
    static var arrAutoCompTags = [String]()
    static var arrSites = NSMutableArray() // it stores the sites
    static var arrSites2 = [String]()
    static let kBaseURL = ""
    static let appThemeColor = UIColor(red: 22.0/255.0, green: 134.0/255.0, blue: 177.0/255.0, alpha: 1.0)
    static let appHeaderColor = UIColor(red: 82.0/255.0, green: 175.0/255.0, blue: 204.0/255.0, alpha: 1.0)
   // static let appHeaderColor = UIColor(red: 98.0/255.0, green: 189.0/255.0, blue: 241.0/255.0, alpha: 1.0) 117, 215, 239
    static let appStatusBarColor = UIColor(red: 90.0/255.0, green: 191.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    static let client_id = "6886eb225853ecf0fc085f334b0b09406ea222454a0b9f5a4288fcc1f137775b"
    static let redirect_uri = "https://www.handynationapp.com/price-for-your-nation/"
    static let redirect_uri_thankYou = "https://www.handynationapp.com/registration-complete/"
    
    // Images of radio button
   static let checkedImage = UIImage(named: "imgRadioSelect")! as UIImage
   static let uncheckedImage = UIImage(named: "imgRadioUnselect")! as UIImage

   static let checkBoxSelect = UIImage(named: "imgCheckBoxSelect")! as UIImage
   static let checkBoxUnSelect = UIImage(named: "imgCheckBoxUnSelect")! as UIImage
    
    static var isList = false
    static var isTagWidth = false
    public static var VieWidth:CGFloat = CGFloat()
    public static var VieWidth2:CGFloat = CGFloat()
   
    
    // used for the search of firstName & lastName // here F = firstName & L = lastName //
    public static let FL_NAME_BOTH = 1;
    public static let LF_NAME = 2;
    public static let FL_BOTH_SAME = 3;
    public static let F_NAME = 4;
    public static let L_NAME = 5;
}



