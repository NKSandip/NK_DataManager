//
//  Images.swift
//  PSKit
//
//  Created by Aamir  on 6/22/16.
//  Copyright © 2016 Aamir . All rights reserved.
//

import Foundation

open class Images : NSObject {
  open  var position : String
  open  var url : String
    
    internal init(data: NSDictionary){

        self.position = isNull(data["option_id"] as? String as AnyObject?) ? "" : data["option_id"] as! String
        self.url = isNull(data["url"] as? String as AnyObject?) ? "" : data["url"] as! String
        
    }
}
