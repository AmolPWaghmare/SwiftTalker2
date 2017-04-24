//
//  TweetCell.swift
//  Swift Talker
//
//  Created by Waghmare, Amol on 16/04/17.
//  Copyright © 2017 Waghmare, Amol. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func tweetCell (tweetCell: TweetCell, selectImageInCell user: User)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    var user_id_str: String?
    
    weak var delegate: TweetCellDelegate?
    
    var tweet : Tweet! {
        didSet {
            
            let tweetBy = tweet.tweetBy
            
            user_id_str = tweetBy?.id_str
            
            userImage.setImageWith((tweetBy?.profileURL!)!)
            
            let fullScreenName = "@" + (tweetBy?.screenName)!
            userScreenName.text = fullScreenName
            userName.text = tweetBy?.name
            
            tweetText.text = tweet.text
            timeText.text = tweet.timestampStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTap(sender:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func onImageTap(sender: UITapGestureRecognizer) {
        
        var queryParams = [String: AnyObject]()
        queryParams["user_id"] = user_id_str as AnyObject
        
        TwitterClient.sharedInstance?.getOtherUserInfo(parameters:queryParams, success: { (user : User) in
            self.delegate?.tweetCell!(tweetCell: self, selectImageInCell: user)
        }, failure: { (error: Error) in
            print("error \(error.localizedDescription)")
        })
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
