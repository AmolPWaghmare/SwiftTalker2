//
//  User.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var tagLine: NSString?
    
    init(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? NSString
        screenName = dictionary["screen_name"] as? NSString
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = NSURL(string: profileURLString)
        }
        tagLine = dictionary["description"] as? NSString
    }
    

}
