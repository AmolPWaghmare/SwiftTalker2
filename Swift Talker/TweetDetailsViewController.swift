//
//  TweetDetailsViewController.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 16/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var userNamelabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var favouriteCountsLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
        if tweet != nil {
            
            let tweetBy = tweet.tweetBy
            
            userProfileImage.setImageWith((tweetBy?.profileURL!)!)
            
            userNamelabel.text = tweetBy?.name
            let fullScreenName = "@" + (tweetBy?.screenName)!
            screenNameLabel.text = fullScreenName
            
            tweetText.text = tweet.text
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M/dd/yy, h:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            timeLabel.text = formatter.string(from: (tweet?.timestamp)! as Date)
            
            retweetCountLabel.text = String(tweet.retweetCount)
            if tweet.retweetCount > 1 {
                retweetLabel.text = "RETWEETS"
            } else {
                retweetLabel.text = "RETWEET"
            }
            favouriteCountsLabel.text = String(tweet.favoritesCount)
            if tweet.favoritesCount > 1 {
                favouritesLabel.text = "LIKES"
            } else {
                favouritesLabel.text = "LIKE"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
