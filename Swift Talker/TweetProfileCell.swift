//
//  TweetProfileCell.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 23/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

class TweetProfileCell: UITableViewCell {
    
//    @IBOutlet weak var userScreenName: UILabel!
//    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var userImage: UIImageView!
//    @IBOutlet weak var timeText: UILabel!
//    @IBOutlet weak var tweetText: UILabel!
    
    
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeTweet: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    var tweet : Tweet! {
        didSet {
            
            let tweetBy = tweet.tweetBy
            
            userImage.setImageWith((tweetBy?.profileURL!)!)
            
            let fullScreenName = "@" + (tweetBy?.screenName)!
            userScreenName.text = fullScreenName
            userName.text = tweetBy?.name
            
            tweetText.text = tweet.text
            timeTweet.text = tweet.timestampStr
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
