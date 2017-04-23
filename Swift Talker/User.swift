//
//  User.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var id_str: String?
    var screenName: String?
    var profileURL: URL?
    var backgroundURL: URL?
    var tagLine: String?
    var followers_count: Int? = 0
    var following_count: Int? = 0
    var statuses_count: Int? = 0
    
    var originalDictionary : NSDictionary?
    
    init(dictionary: NSDictionary) {
        
        originalDictionary = dictionary
        
        name = dictionary["name"] as? String
        id_str = dictionary["id_str"] as? String

        screenName = dictionary["screen_name"] as? String
        statuses_count = (dictionary["statuses_count"] as? Int) ?? 0
        followers_count = (dictionary["followers_count"] as? Int) ?? 0
        following_count = (dictionary["favourites_count"] as? Int) ?? 0
        
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        let backgroudURLString = dictionary["profile_banner_url"] as? String
        if let backgroudURLString = backgroudURLString {
            backgroundURL = URL(string: backgroudURLString)
        }
        tagLine = dictionary["description"] as? String
    }
    
    static var _currentUser : User?
    
    class var currentUser : User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserDict") as? Data
                
                if let userData = userData {
                    let userDict = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: userDict)
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let dataDict = try! JSONSerialization.data(withJSONObject: user.originalDictionary!, options: [])
                
                defaults.set(dataDict, forKey: "currentUserDict")
            } else {
                defaults.removeObject(forKey: "currentUserDict")
            }
            defaults.synchronize()
        }
    }
    

}
