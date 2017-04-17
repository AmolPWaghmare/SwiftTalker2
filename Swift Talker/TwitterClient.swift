//
//  TwitterClient.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseUrl = "https://api.twitter.com"
let twitterConsumerKey = "GpN5HiZsdOpfM7fA0fsPXm9zy"
let twitterConsumerSecret = "dA5AxyPVQPkskaq2lZgx802Fw24MAeeYBmPDKo8EV5OmmO14hY"
let twitterCallbackURL = "swifttalker://oauth"

//API
let TWITTER_REQUEST_TOKEN = "oauth/request_token"
let TWITTER_ACCESS_TOKEN = "oauth/access_token"
let TWITTER_AUTHORIZE = "https://api.twitter.com/oauth/authorize?oauth_token="
let TWITTER_USER_INFO = "1.1/account/verify_credentials.json"
let TWITTER_HOME_TIMELINE = "1.1/statuses/home_timeline.json"
let TWITTER_TWEET = "1.1/statuses/update.json"


class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string : twitterBaseUrl)!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess : (() -> ())?
    var loginFailure : ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure : @escaping (Error) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: TWITTER_REQUEST_TOKEN, method: "GET", callbackURL: URL(string: twitterCallbackURL), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let token = String(requestToken!.token)
            
            let authURL = URL(string: TWITTER_AUTHORIZE + token!)!
            UIApplication.shared.open(authURL, options: [:], completionHandler: { (opened: Bool) in
                
            })
            
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: .userDidLogoutNotificationName, object: nil)
    }
    
    func handleOpenURL(url : URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: TWITTER_ACCESS_TOKEN, method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
            
            self.getUserInfo(success: { (user : User) in
                
                User.currentUser = user
                
                self.loginSuccess?()
            }, failure: { (error: Error!) in
                self.loginFailure?(error)
            })
            
        }, failure: { (error:Error!) in
            self.loginFailure?(error)
        })
    }
    
    func getUserInfo (success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get(TWITTER_USER_INFO, parameters: nil, progress: nil,
             success: { (task: URLSessionDataTask, response: Any?) in
            
                let userDict = response as! NSDictionary
                let user = User(dictionary: userDict)
                success(user)
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            })

    }
    
    func getHomeTimeline (parameters: [String: AnyObject]?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
        get(TWITTER_HOME_TIMELINE, parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweetsDict = response as! [NSDictionary]
                let tweets = Tweet.tweetsFromArray(dictionaries: tweetsDict)
    
                success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        )
    }
    
    func tweet (tweetText: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let queryParameters = ["status" : tweetText]
        
        post(TWITTER_TWEET, parameters: queryParameters, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                let tweet = Tweet.init(dictionary: response as! NSDictionary)
                success(tweet)
        
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            }
        )
    }

}
