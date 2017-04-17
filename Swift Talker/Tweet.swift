//
//  Tweet.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 15/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: String?
    var text: String?
    var timestamp: NSDate?
    var timestampStr: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var retweetBy : User?
    var tweetBy : User?
    
    init(dictionary: NSDictionary) {
        super.init()
        
        id = dictionary["id_str"] as? String
        
        let retweetStatus = dictionary["retweeted_status"] as?NSDictionary
        if retweetStatus != nil {
            
            text = retweetStatus?["text"] as? String
            retweetCount = (retweetStatus?["retweet_count"] as? Int) ?? 0
            favoritesCount = (retweetStatus?["favourites_count"] as? Int) ?? 0
            
            let timeStampString = retweetStatus?["created_at"] as? String
            
            if let timeStampString = timeStampString {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                timestamp = formatter.date(from: timeStampString)! as NSDate
            }
            
            let retweetedUserDict = retweetStatus?["user"] as! NSDictionary
            tweetBy = User(dictionary: retweetedUserDict)
            
            let userDict = dictionary["user"] as! NSDictionary
            retweetBy = User(dictionary: userDict)
        }
        else {
            text = dictionary["text"] as? String
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
            
            let timeStampString = dictionary["created_at"] as? String
            
            if let timeStampString = timeStampString {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                timestamp = formatter.date(from: timeStampString)! as NSDate
            }
            
            let userDict = dictionary["user"] as! NSDictionary
            tweetBy = User(dictionary: userDict)
        }
        
        timestampStr = getTimeAsText(timeStamp: timestamp!)
    }
    
    private func getTimeAsText(timeStamp: NSDate) ->String {
        let timeSinceNow = Int(fabs(timeStamp.timeIntervalSinceNow))
        
        if (timeSinceNow < 3600) {
            let minutes = Int(timeSinceNow/60)
            return "\(minutes)m"
        }
        else if (timeSinceNow < (3600*24)) {
            let hours = Int(timeSinceNow/(60*60))
            return "\(hours)h"
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/dd/yy"
            let str = formatter.string(from: ((timeStamp) as NSDate) as Date)
            return str
        }
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
