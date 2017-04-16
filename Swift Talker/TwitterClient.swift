//
//  TwitterClient.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string : "https://api.twitter.com")!, consumerKey: "GpN5HiZsdOpfM7fA0fsPXm9zy", consumerSecret: "dA5AxyPVQPkskaq2lZgx802Fw24MAeeYBmPDKo8EV5OmmO14hY")
    
    var loginSuccess : (() -> ())?
    var loginFailure : ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure : @escaping (Error) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "swifttalker://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let token = String(requestToken!.token)
            
            let authURL = URL(string:"https://api.twitter.com/oauth/authorize?oauth_token=" + token!)!
            UIApplication.shared.open(authURL, options: [:], completionHandler: { (opened: Bool) in
                
            })
            
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func handleOpenURL(url : URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
            
            self.loginSuccess?()
            
//            twitterClient?.getUserInfo(success: { (user: User) in
//                print("User info : \(user.name ?? "")")
//                
//            }, failure: { (error: Error) in
//                print("error \(error.localizedDescription)")
//            })
//            

            
            
        }, failure: { (error:Error!) in
            self.loginFailure?(error)
        })
    }
    
    func getUserInfo (success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
            
                let userDict = response as! NSDictionary
                let user = User(dictionary: userDict)
                success(user)
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            })

    }
    
    func getHomeTimeline (success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDict = response as! [NSDictionary]
                let tweets = Tweet.tweetsFromArray(dictionaries: tweetsDict)
    
                success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

}
